import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'
    show
        VideoPlayer,
        VideoPlayerController,
        VideoPlayerValue,
        VideoProgressColors,
        VideoProgressIndicator;
import 'package:youtube_player_iframe/youtube_player_iframe.dart'
    show
        PlayerState,
        YoutubePlayer,
        YoutubePlayerController,
        YoutubePlayerParams,
        YoutubePlayerValue;

// Ajuste este caminho se a pasta do Explorar ficar em outro lugar.
import '../../pages_configurar/controle_objetivo.dart'
    show ControleObjetivos, EstadoSessao, formatarDuracao;
import 'explorar_controller.dart';
import 'explorar_estilo.dart';
import 'explorar_model.dart';

// =====================================================================
// TELA
// =====================================================================

/// Reproduz um vídeo respeitando a sessão do Ikai.
///
/// Regras:
/// - NÃO existe cronômetro aqui. O tempo é o do `ControleObjetivos`, que
///   continua contando normalmente durante a reprodução.
/// - Se a sessão deixar de estar ativa, o vídeo é pausado e liberado na hora.
///   Além disso, o `SessaoGuard` já remove o Navigator inteiro (e esta tela
///   junto) quando o tempo acaba.
/// - Ao ir para segundo plano o vídeo é pausado, para o som não continuar
///   tocando fora do app depois que a sessão expirar.
class VideoPlayerPage extends StatefulWidget {
  final ConteudoExplorar conteudo;
  final ExplorarController controller;
  final String categoriaTitulo;

  const VideoPlayerPage({
    super.key,
    required this.conteudo,
    required this.controller,
    required this.categoriaTitulo,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with WidgetsBindingObserver {
  final ControleObjetivos _sessao = ControleObjetivos.instance;

  _Reprodutor? _reprodutor;
  String? _erro;
  bool _concluidoAgora = false;
  bool _encerrado = false; // reprodução já foi encerrada/liberada
  bool _comecou = false; // chegou a tocar pelo menos uma vez

  int _posicaoSeg = 0;

  // "Tempo assistido": cronômetro local só para medir o que foi reproduzido
  // (roda apenas enquanto o vídeo toca). Não tem relação com a sessão.
  final Stopwatch _assistindo = Stopwatch();
  int _assistidoJaSalvo = 0;
  DateTime _ultimoSalvamento = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sessao.addListener(_aoMudarSessao);

    if (_sessao.estado != EstadoSessao.ativa) {
      _erro = 'Sua sessão não está ativa.';
      _encerrado = true;
      return;
    }
    _iniciarReprodutor();
  }

  void _iniciarReprodutor() {
    final c = widget.conteudo;
    final inicio = widget.controller.posicaoParaRetomar(c);
    final inicioAjustado = inicio > 2 ? inicio - 2 : inicio; // volta 2 s
    _posicaoSeg = inicioAjustado;

    final eventos = _Eventos(
      aoMudarTocando: _aoMudarTocando,
      aoTerminar: _aoTerminar,
      aoErro: _aoErro,
      aoPosicao: _aoPosicao,
    );

    switch (c.provedor) {
      case ProvedorVideo.youtube:
        _reprodutor = _ReprodutorYoutube(
          videoId: c.videoId!,
          inicioSegundos: inicioAjustado,
          eventos: eventos,
        );
      case ProvedorVideo.arquivo:
        _reprodutor = _ReprodutorArquivo(
          uri: Uri.parse(c.urlVideo!),
          inicioSegundos: inicioAjustado,
          eventos: eventos,
        );
      case null:
        _erro = 'Este conteúdo não tem uma fonte de vídeo válida.';
        _encerrado = true;
    }
  }

  // ------------------------------------------------------------------
  // Sessão
  // ------------------------------------------------------------------

  void _aoMudarSessao() {
    if (_sessao.estado != EstadoSessao.ativa) _interromper();
  }

  /// Para tudo imediatamente (sessão acabou). Idempotente.
  void _interromper() {
    if (_encerrado) return;
    _encerrado = true;
    if (_assistindo.isRunning) _assistindo.stop();
    _salvarProgresso();

    final r = _reprodutor;
    _reprodutor = null;
    r?.pausar(); // silencia já
    // Libera depois do próximo frame, com o widget do player já fora da árvore.
    WidgetsBinding.instance.addPostFrameCallback((_) => r?.liberar());

    if (mounted) {
      setState(() => _erro = 'Sua sessão terminou. A reprodução foi encerrada.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    if (_encerrado) return;
    if (estado == AppLifecycleState.paused ||
        estado == AppLifecycleState.hidden) {
      _reprodutor?.pausar();
      _salvarProgresso();
    }
    // Ao voltar, o SessaoGuard chama `verificar()`; se o tempo acabou, ele
    // remove esta tela e `_aoMudarSessao` encerra o player.
  }

  // ------------------------------------------------------------------
  // Eventos do player
  // ------------------------------------------------------------------

  void _aoMudarTocando(bool tocando) {
    if (_encerrado) return;
    if (tocando) {
      if (_sessao.estado != EstadoSessao.ativa) {
        _interromper();
        return;
      }
      _comecou = true;
      if (!_assistindo.isRunning) _assistindo.start();
    } else {
      if (_assistindo.isRunning) _assistindo.stop();
      _salvarProgresso();
    }
  }

  void _aoPosicao(int segundos) {
    if (_encerrado) return;
    _posicaoSeg = segundos;
    final agora = DateTime.now();
    if (agora.difference(_ultimoSalvamento) >= const Duration(seconds: 10)) {
      _ultimoSalvamento = agora;
      _salvarProgresso();
    }
  }

  void _aoTerminar() {
    if (_encerrado) return;
    if (_assistindo.isRunning) _assistindo.stop();
    _comecou = true;
    _salvarProgresso(concluido: true);
    if (mounted) setState(() => _concluidoAgora = true);
  }

  void _aoErro(String mensagem) {
    if (_encerrado) return;
    _encerrado = true;
    if (_assistindo.isRunning) _assistindo.stop();
    _salvarProgresso();
    final r = _reprodutor;
    _reprodutor = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => r?.liberar());
    if (mounted) setState(() => _erro = mensagem);
  }

  /// Registra o progresso no controller (que grava no SharedPreferences).
  void _salvarProgresso({bool concluido = false}) {
    if (!_comecou && _posicaoSeg == 0 && !concluido) return;
    final total = _assistindo.elapsed.inSeconds;
    final adicional = total - _assistidoJaSalvo;
    _assistidoJaSalvo = total;

    final dur = widget.conteudo.duracaoSegundos;
    final terminou = concluido ||
        (dur != null && dur > 0 && _posicaoSeg >= dur * 0.95);

    widget.controller.registrarProgresso(
      widget.conteudo,
      posicaoSegundos: _posicaoSeg,
      assistidoAdicionalSegundos: adicional < 0 ? 0 : adicional,
      concluido: terminou,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessao.removeListener(_aoMudarSessao);
    if (!_encerrado) {
      if (_assistindo.isRunning) _assistindo.stop();
      _salvarProgresso();
    }
    final r = _reprodutor;
    _reprodutor = null;
    r?.liberar();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // Interface
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final c = widget.conteudo;
    final fonte = c.fonteNome;

    return Scaffold(
      backgroundColor: EstiloIkai.fundo,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: EstiloIkai.larguraMaxima),
            child: Column(
              children: [
                BarraTopoConteudo(titulo: widget.categoriaTitulo),
                _areaVideo(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(EstiloIkai.margem),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _avisoDeTempo(),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            RotuloChip(
                              texto: c.rotuloFormato,
                              icone: Icons.play_circle_outline,
                              cor: EstiloIkai.laranja,
                              fundo: EstiloIkai.laranjaSuave,
                            ),
                            RotuloChip(texto: widget.categoriaTitulo),
                            if (c.duracaoSegundos != null)
                              RotuloChip(
                                texto: formatarRelogio(c.duracaoSegundos!),
                                icone: Icons.schedule,
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          c.titulo,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: EstiloIkai.titulo,
                          ),
                        ),
                        if (fonte != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            fonte,
                            style: const TextStyle(
                              fontSize: 13,
                              color: EstiloIkai.subtitulo,
                            ),
                          ),
                        ],
                        if (_concluidoAgora) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: EstiloIkai.laranja,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Você concluiu este conteúdo.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: EstiloIkai.titulo,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (c.descricao.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            c.descricao,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: EstiloIkai.subtitulo,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _areaVideo(BuildContext context) {
    final altura = MediaQuery.sizeOf(context).height;
    final r = _reprodutor;

    final Widget miolo;
    if (_erro != null) {
      miolo = AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.white70, size: 36),
                const SizedBox(height: 8),
                Text(
                  _erro!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (r == null) {
      miolo = const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: CircularProgressIndicator(color: EstiloIkai.laranja),
        ),
      );
    } else {
      miolo = r.vista(context);
    }

    // Limita a altura (telefone deitado) sem estourar a tela.
    return Container(
      width: double.infinity,
      color: Colors.black,
      constraints: BoxConstraints(maxHeight: altura * 0.55),
      alignment: Alignment.center,
      child: miolo,
    );
  }

  /// Avisa quando o que falta do vídeo é maior que o tempo da sessão.
  Widget _avisoDeTempo() {
    final dur = widget.conteudo.duracaoSegundos;
    if (dur == null || _erro != null) return const SizedBox.shrink();

    return ValueListenableBuilder<Duration>(
      valueListenable: _sessao.restante,
      builder: (_, restante, __) {
        final faltaDoVideo = (dur - _posicaoSeg).clamp(0, dur).toInt();
        if (restante.inSeconds >= faltaDoVideo) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: EstiloIkai.laranjaSuave,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.hourglass_bottom_rounded,
                size: 18,
                color: EstiloIkai.laranja,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Faltam ${formatarDuracao(restante.inSeconds)} na sua '
                  'sessão, e ainda restam ${formatarDuracao(faltaDoVideo)} '
                  'deste vídeo. A reprodução será interrompida quando o '
                  'tempo acabar.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: EstiloIkai.titulo,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================================
// ADAPTADORES DE REPRODUÇÃO
// (um para YouTube, outro para arquivo/HLS; a tela não sabe a diferença)
// =====================================================================

class _Eventos {
  final void Function(bool tocando) aoMudarTocando;
  final VoidCallback aoTerminar;
  final void Function(String mensagem) aoErro;
  final void Function(int segundos) aoPosicao;

  const _Eventos({
    required this.aoMudarTocando,
    required this.aoTerminar,
    required this.aoErro,
    required this.aoPosicao,
  });
}

abstract class _Reprodutor {
  Widget vista(BuildContext context);
  Future<void> pausar();
  Future<void> liberar();
}

/// YouTube pelo player oficial incorporado (IFrame Player API), que é a
/// forma permitida de exibir vídeos do YouTube em um app.
class _ReprodutorYoutube implements _Reprodutor {
  _ReprodutorYoutube({
    required String videoId,
    required int inicioSegundos,
    required _Eventos eventos,
  }) : _eventos = eventos {
    _yt = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      startSeconds: inicioSegundos > 0 ? inicioSegundos.toDouble() : null,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        interfaceLanguage: 'pt',
        captionLanguage: 'pt',
      ),
    );
    _subValor = _yt.listen(_aoMudarValor);
    _subPosicao = _yt.videoStateStream.listen(
      (estado) => _eventos.aoPosicao(estado.position.inSeconds),
    );
  }

  final _Eventos _eventos;
  late final YoutubePlayerController _yt;
  StreamSubscription<YoutubePlayerValue>? _subValor;
  StreamSubscription<dynamic>? _subPosicao;
  bool _tocando = false;
  bool _terminou = false;
  bool _liberado = false;

  void _aoMudarValor(YoutubePlayerValue v) {
    if (_liberado) return;
    if (v.hasError) {
      _eventos.aoErro(
        'Este vídeo não pode ser reproduzido aqui. Tente outro conteúdo.',
      );
      return;
    }
    final tocando = v.playerState == PlayerState.playing;
    if (tocando != _tocando) {
      _tocando = tocando;
      _eventos.aoMudarTocando(tocando);
    }
    if (tocando) _terminou = false;
    if (v.playerState == PlayerState.ended && !_terminou) {
      _terminou = true;
      _eventos.aoTerminar();
    }
  }

  @override
  Widget vista(BuildContext context) =>
      YoutubePlayer(controller: _yt, aspectRatio: 16 / 9);

  @override
  Future<void> pausar() async {
    if (_liberado) return;
    try {
      await _yt.pauseVideo();
    } catch (_) {
      // Player já fechado: nada a fazer.
    }
  }

  @override
  Future<void> liberar() async {
    if (_liberado) return;
    _liberado = true;
    await _subValor?.cancel();
    await _subPosicao?.cancel();
    try {
      await _yt.close();
    } catch (_) {
      // Já liberado.
    }
  }
}

/// Arquivo de vídeo (mp4, HLS...) em https, pelo pacote oficial video_player.
class _ReprodutorArquivo implements _Reprodutor {
  _ReprodutorArquivo({
    required Uri uri,
    required int inicioSegundos,
    required _Eventos eventos,
  }) : _eventos = eventos {
    _vp = VideoPlayerController.networkUrl(uri);
    _iniciar(inicioSegundos);
  }

  final _Eventos _eventos;
  late final VideoPlayerController _vp;
  bool _tocando = false;
  bool _terminou = false;
  bool _liberado = false;

  Future<void> _iniciar(int inicioSegundos) async {
    try {
      await _vp.initialize();
      if (_liberado) return;
      _vp.addListener(_ouvir);
      if (inicioSegundos > 0) {
        await _vp.seekTo(Duration(seconds: inicioSegundos));
      }
      if (_liberado) return;
      await _vp.play();
    } catch (_) {
      if (!_liberado) {
        _eventos.aoErro('Não foi possível carregar este vídeo agora.');
      }
    }
  }

  void _ouvir() {
    if (_liberado) return;
    final v = _vp.value;
    if (v.hasError) {
      _eventos.aoErro('Não foi possível reproduzir este vídeo.');
      return;
    }
    if (v.isPlaying != _tocando) {
      _tocando = v.isPlaying;
      _eventos.aoMudarTocando(_tocando);
    }
    _eventos.aoPosicao(v.position.inSeconds);
    if (v.isCompleted && !_terminou) {
      _terminou = true;
      _eventos.aoTerminar();
    } else if (!v.isCompleted) {
      _terminou = false;
    }
  }

  @override
  Widget vista(BuildContext context) => _VistaArquivo(controller: _vp);

  @override
  Future<void> pausar() async {
    if (_liberado) return;
    try {
      await _vp.pause();
    } catch (_) {
      // Ainda não inicializado ou já liberado.
    }
  }

  @override
  Future<void> liberar() async {
    if (_liberado) return;
    _liberado = true;
    try {
      _vp.removeListener(_ouvir);
      await _vp.dispose();
    } catch (_) {
      // Já liberado.
    }
  }
}

/// Vídeo com controles mínimos: tocar/pausar, barra de progresso e tempo.
class _VistaArquivo extends StatelessWidget {
  final VideoPlayerController controller;
  const _VistaArquivo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, v, _) {
        if (!v.isInitialized) {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(
              child: CircularProgressIndicator(color: EstiloIkai.laranja),
            ),
          );
        }
        return AspectRatio(
          aspectRatio: v.aspectRatio > 0 ? v.aspectRatio : 16 / 9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(controller),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => v.isPlaying ? controller.pause() : controller.play(),
                  child: AnimatedOpacity(
                    opacity: v.isPlaying ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                child: Row(
                  children: [
                    Text(
                      formatarRelogio(v.position.inSeconds),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: EstiloIkai.laranja,
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatarRelogio(v.duration.inSeconds),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}