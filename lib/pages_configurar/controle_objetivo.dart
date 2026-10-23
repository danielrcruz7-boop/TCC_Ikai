import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages_login/login.dart';
import './objetivo_conteudo.dart';
import './objetivo_estudo.dart';
import './objetivo_leitura.dart';
import './tela_temporaria2.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// =====================================================
// MODELOS E CATÁLOGO
// =====================================================

class Categoria {
  final String id;
  final String titulo;
  final IconData icone;
  const Categoria({
    required this.id,
    required this.titulo,
    required this.icone,
  });
}

/// Dados que o controlador entrega à tela de categorias de cada objetivo.
class PropsCategorias {
  final String? selecionadaId;
  final String? sugeridaId;
  final ValueChanged<Categoria> aoSelecionar;
  const PropsCategorias({
    required this.selecionadaId,
    required this.sugeridaId,
    required this.aoSelecionar,
  });
}

class Objetivo {
  final String id;
  final String titulo;
  final IconData icone;
  final List<Categoria> categorias;
  final Widget Function(PropsCategorias props) construirTela;

  const Objetivo({
    required this.id,
    required this.titulo,
    required this.icone,
    required this.categorias,
    required this.construirTela,
  });

  Categoria? buscarCategoria(String? categoriaId) {
    if (categoriaId == null) return null;
    for (final c in categorias) {
      if (c.id == categoriaId) return c;
    }
    return null;
  }
}

/// Única lista de objetivos. Para criar um objetivo novo:
/// crie o arquivo dele e inclua-o aqui.
List<Objetivo> get todosOsObjetivos => [
      objetivoConteudo,
      objetivoLeitura,
      objetivoEstudo,
    ];

Objetivo? buscarObjetivo(String? id) {
  if (id == null) return null;
  for (final o in todosOsObjetivos) {
    if (o.id == id) return o;
  }
  return null;
}

// =====================================================
// DURAÇÃO (VALIDAÇÃO NA LÓGICA, NÃO SÓ NA INTERFACE)
// =====================================================

const int duracaoMaximaSegundos = 10800; // 3 horas

bool duracaoValida(int totalSegundos) =>
    totalSegundos > 0 && totalSegundos <= duracaoMaximaSegundos;

String formatarDuracao(int s) {
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  final partes = <String>[];
  if (h > 0) partes.add('${h}h');
  if (m > 0) partes.add('${m}min');
  if (sec > 0 || partes.isEmpty) partes.add('${sec}s');
  return partes.join(' ');
}

// =====================================================
// CONTROLADOR CENTRAL (ESCOLHAS + HISTÓRICO + SESSÃO + TEMPO)
// =====================================================

enum EstadoSessao { naoIniciada, ativa, expirada }

/// Fonte de verdade de tudo. Escolhas e sessão ficam só em memória;
/// apenas o histórico (sugestões) é gravado no aparelho.
class ControleObjetivos extends ChangeNotifier {
  ControleObjetivos._();
  static final ControleObjetivos instance = ControleObjetivos._();

  static const _kObjetivo = 'hist_objetivo_id';
  static const _kCategoria = 'hist_categoria_id';
  static const _kDuracao = 'hist_duracao_s';

  // ---------- Escolhas do ciclo atual (sempre começam vazias) ----------
  int etapa = 0; // 0 objetivo, 1 categoria, 2 duração
  Objetivo? objetivo;
  Categoria? categoria;
  int horas = 0;
  int minutos = 0;
  int segundos = 0;

  int get duracaoSegundos => horas * 3600 + minutos * 60 + segundos;

  // ---------- Histórico (só sugestões) ----------
  bool historicoCarregado = false;
  String? _hObjetivo;
  String? _hCategoria;
  int? _hDuracao;

  Future<void> carregarHistorico() async {
    if (historicoCarregado) return;
    try {
      final p = await SharedPreferences.getInstance();
      _hObjetivo = p.getString(_kObjetivo);
      _hCategoria = p.getString(_kCategoria);
      _hDuracao = p.getInt(_kDuracao);
    } catch (_) {
      // Falha de leitura nunca impede o uso.
    }
    historicoCarregado = true;
    notifyListeners();
  }

  Future<void> _salvarHistorico(String o, String c, int s) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kObjetivo, o);
      await p.setString(_kCategoria, c);
      await p.setInt(_kDuracao, s);
      _hObjetivo = o;
      _hCategoria = c;
      _hDuracao = s;
    } catch (_) {
      // Falha ao gravar não impede o uso.
    }
  }

  String? get sugestaoObjetivoId => buscarObjetivo(_hObjetivo)?.id;

  /// Só sugere categoria que pertença ao objetivo escolhido agora.
  String? get sugestaoCategoriaId =>
      objetivo?.buscarCategoria(_hCategoria)?.id;

  int? get sugestaoDuracao {
    final d = _hDuracao;
    return (d != null && duracaoValida(d)) ? d : null;
  }

  // ---------- Ações de escolha (sempre explícitas) ----------
  void selecionarObjetivo(Objetivo o) {
    if (_estado != EstadoSessao.naoIniciada) return;
    if (objetivo?.id != o.id) categoria = null; // invalida categoria incompatível
    objetivo = o;
    notifyListeners();
  }

  void selecionarCategoria(Categoria c) {
    if (_estado != EstadoSessao.naoIniciada) return;
    if (objetivo?.buscarCategoria(c.id) == null) return; // incompatível
    categoria = c;
    notifyListeners();
  }

  void definirDuracao(int h, int m, int s) {
    if (_estado != EstadoSessao.naoIniciada) return;
    horas = h;
    minutos = m;
    segundos = s;
    notifyListeners();
  }

  /// Chamado só quando o usuário TOCA na sugestão de duração.
  void aplicarSugestaoDuracao() {
    final d = sugestaoDuracao;
    if (d == null) return;
    definirDuracao(d ~/ 3600, (d % 3600) ~/ 60, d % 60);
  }

  bool get podeAvancar {
    switch (etapa) {
      case 0:
        return objetivo != null;
      case 1:
        return objetivo != null &&
            categoria != null &&
            objetivo!.buscarCategoria(categoria!.id) != null;
      default:
        return duracaoValida(duracaoSegundos);
    }
  }

  void avancar() {
    if (!podeAvancar || etapa >= 2) return;
    etapa++;
    notifyListeners();
  }

  void voltar() {
    if (etapa == 0) return;
    etapa--;
    notifyListeners();
  }

  bool _confirmando = false;

  /// Confirmação final explícita. Única porta de entrada da sessão.
  Future<bool> confirmar() async {
    if (_confirmando) return false;
    if (_estado != EstadoSessao.naoIniciada || etapa != 2 || !podeAvancar) {
      return false;
    }
    final o = objetivo!;
    final c = categoria!;
    final s = duracaoSegundos;
    if (o.buscarCategoria(c.id) == null || !duracaoValida(s)) return false;

    _confirmando = true;
    await _salvarHistorico(o.id, c.id, s);
    _iniciar(s);
    _confirmando = false;
    return true;
  }

  // ---------- Sessão e cronômetro ----------
  EstadoSessao _estado = EstadoSessao.naoIniciada;
  Duration? _duracao;
  DateTime? _inicio;
  final Stopwatch _relogio = Stopwatch();
  Timer? _timer;

  /// Tempo restante, atualizado a cada segundo (para exibir na UI).
  final ValueNotifier<Duration> restante = ValueNotifier(Duration.zero);

  EstadoSessao get estado => _estado;

  void _iniciar(int segundosTotais) {
    if (_estado != EstadoSessao.naoIniciada) return; // nunca 2 sessões
    _duracao = Duration(seconds: segundosTotais);
    _inicio = DateTime.now();
    _relogio
      ..reset()
      ..start();
    restante.value = _duracao!;
    _estado = EstadoSessao.ativa;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => verificar());
    notifyListeners();
  }

  /// Recalcula o restante. Também é chamado ao voltar do segundo plano.
  /// Usa o maior entre relógio de parede e cronômetro monotônico.
  void verificar() {
    if (_estado != EstadoSessao.ativa) return;
    final parede = DateTime.now().difference(_inicio!);
    final decorrido = parede > _relogio.elapsed ? parede : _relogio.elapsed;
    final falta = _duracao! - decorrido;
    if (falta <= Duration.zero) {
      _expirar();
    } else {
      restante.value = falta;
    }
  }

  void _expirar() {
    if (_estado != EstadoSessao.ativa) return; // processa uma única vez
    _timer?.cancel();
    _timer = null;
    _relogio.stop();
    _estado = EstadoSessao.expirada; // estado terminal: não há volta
    restante.value = Duration.zero;
    notifyListeners();
  }

  /// Reinicia o controlador para permitir a criação de uma nova sessão.
  void reiniciarSessao() {
    _timer?.cancel();
    _timer = null;
    _relogio.stop();
    _relogio.reset();
    _estado = EstadoSessao.naoIniciada;
    etapa = 0;
    objetivo = null;
    categoria = null;
    horas = 0;
    minutos = 0;
    segundos = 0;
    restante.value = Duration.zero;
    notifyListeners();
  }
}

// =====================================================
// ESTILO (IGUAL AO DAS SUAS TELAS ATUAIS)
// =====================================================

const Color _laranja = Color(0xFFCB5A34);
const Color _fundo = Color(0xFFF7F8F4);
const Color _titulo = Color(0xFF253D2D);
const Color _subtitulo = Color(0xFF68756B);

/// Card de opção usado nas 3 etapas. Três estados visuais:
/// normal (borda cinza), sugerido (borda azulada + selo "Sugestão")
/// e selecionado (fundo verde claro, borda laranja, check).
class OpcaoCard extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final bool selecionado;
  final bool sugerido;
  final VoidCallback onTap;

  const OpcaoCard({
    super.key,
    required this.titulo,
    required this.icone,
    required this.selecionado,
    required this.sugerido,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mostrarSugestao = sugerido && !selecionado;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFFE4EFE5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado
                ? _laranja
                : mostrarSugestao
                    ? const Color(0xFF8FA3B5)
                    : const Color(0xFFE0E5DF),
            width: (selecionado || mostrarSugestao) ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selecionado
                    ? const Color(0xFFD0E3D2)
                    : const Color(0xFFF0F3EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: _laranja, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263D2D),
                ),
              ),
            ),
            if (mostrarSugestao)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Sugestão',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F6275),
                  ),
                ),
              ),
            Icon(
              selecionado ? Icons.check_circle : Icons.circle_outlined,
              color: selecionado ? _laranja : Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// Lista rolável de categorias, usada pelos 3 arquivos de objetivo.
class ListaCategorias extends StatelessWidget {
  final List<Categoria> categorias;
  final PropsCategorias props;

  const ListaCategorias({
    super.key,
    required this.categorias,
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categorias.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final c = categorias[i];
        return OpcaoCard(
          titulo: c.titulo,
          icone: c.icone,
          selecionado: props.selecionadaId == c.id,
          sugerido: props.sugeridaId == c.id,
          onTap: () => props.aoSelecionar(c),
        );
      },
    );
  }
}

// =====================================================
// FLUXO: OBJETIVO -> CATEGORIA -> DURAÇÃO
// =====================================================

class FluxoObjetivosPage extends StatefulWidget {
  const FluxoObjetivosPage({super.key});

  @override
  State<FluxoObjetivosPage> createState() => _FluxoObjetivosPageState();
}

class _FluxoObjetivosPageState extends State<FluxoObjetivosPage> {
  final ControleObjetivos c = ControleObjetivos.instance;

  void paginaTemporaria() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InicioPage2()),
    );
  }

  @override
  void initState() {
    super.initState();
    c.carregarHistorico();
  }

  bool get _temSugestao {
    switch (c.etapa) {
      case 0:
        return c.sugestaoObjetivoId != null;
      case 1:
        return c.sugestaoCategoriaId != null;
      default:
        return c.sugestaoDuracao != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        if (!c.historicoCarregado) {
          return const Scaffold(
            backgroundColor: _fundo,
            body: Center(child: CircularProgressIndicator(color: _laranja)),
          );
        }

        return PopScope(
          canPop: c.etapa == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) c.voltar();
          },
          child: Scaffold(
            backgroundColor: _fundo,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Etapa ${c.etapa + 1} de 3',
                      style: const TextStyle(
                        backgroundColor: Color(0xFFEDF1F3),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      switch (c.etapa) {
                        0 => 'Qual é o seu objetivo?',
                        1 => 'Qual categoria você quer?',
                        _ => 'Por quanto tempo?',
                      },
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _titulo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _temSugestao
                          ? 'Sua última escolha aparece como sugestão. '
                              'Toque nela para usar ou escolha outra.'
                          : 'Toque em uma opção para selecionar.',
                      style:
                          const TextStyle(fontSize: 15, color: _subtitulo),
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: _conteudo()),
                    const SizedBox(height: 16),
                    _rodape(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _conteudo() {
    switch (c.etapa) {
      case 0:
        final lista = todosOsObjetivos;
        return ListView.separated(
          itemCount: lista.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final o = lista[i];
            return OpcaoCard(
              titulo: o.titulo,
              icone: o.icone,
              selecionado: c.objetivo?.id == o.id,
              sugerido: c.sugestaoObjetivoId == o.id,
              onTap: () => c.selecionarObjetivo(o),
            );
          },
        );
      case 1:
        // Cada objetivo desenha a própria tela de categorias.
        return c.objetivo!.construirTela(
          PropsCategorias(
            selecionadaId: c.categoria?.id,
            sugeridaId: c.sugestaoCategoriaId,
            aoSelecionar: c.selecionarCategoria,
          ),
        );
      default:
        return const _PassoDuracao();
    }
  }

  Widget _rodape() {
    return Row(
      children: [
        if (c.etapa > 0) ...[
          SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: c.voltar,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE0E5DF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(Icons.arrow_back, color: _titulo),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: c.podeAvancar
                  ? () async {
                      if (c.etapa < 2) {
                        c.avancar();
                      } else {
                        final ok = await c.confirmar();
                        if (ok && mounted) paginaTemporaria();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _laranja,
                disabledBackgroundColor: const Color(0xFFCAD5CA),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                c.etapa < 2 ? 'Continuar' : 'Confirmar e entrar',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Seletor livre de duração: horas (0 a 3), minutos e segundos.
class _PassoDuracao extends StatelessWidget {
  const _PassoDuracao();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ControleObjetivos.instance,
      builder: (context, _) => _conteudo(),
    );
  }

  Widget _conteudo() {
    final c = ControleObjetivos.instance;
    final total = c.duracaoSegundos;
    final sugestao = c.sugestaoDuracao;

    String? erro;
    if (total == 0) {
      erro = 'Escolha uma duração maior que zero.';
    } else if (total > duracaoMaximaSegundos) {
      erro = 'O máximo permitido é 3 horas.';
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0E5DF)),
            ),
            child: Column(
              children: [
                const Text(
                  'Duração selecionada',
                  style: TextStyle(fontSize: 13, color: _subtitulo),
                ),
                const SizedBox(height: 6),
                Text(
                  formatarDuracao(total),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: erro == null ? _laranja : Colors.red.shade400,
                  ),
                ),
                if (erro != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    erro,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (sugestao != null && sugestao != total) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: c.aplicarSugestaoDuracao,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8FA3B5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Color(0xFF4F6275)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sugestão: ${formatarDuracao(sugestao)} '
                        '(toque para usar)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F6275),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _linhaSlider(
            'Horas',
            c.horas,
            3,
            (v) => c.definirDuracao(v, c.minutos, c.segundos),
          ),
          _linhaSlider(
            'Minutos',
            c.minutos,
            59,
            (v) => c.definirDuracao(c.horas, v, c.segundos),
          ),
          _linhaSlider(
            'Segundos',
            c.segundos,
            59,
            (v) => c.definirDuracao(c.horas, c.minutos, v),
          ),
        ],
      ),
    );
  }

  Widget _linhaSlider(
    String rotulo,
    int valor,
    int max,
    ValueChanged<int> aoMudar,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 74,
          child: Text(
            rotulo,
            style: const TextStyle(fontSize: 14, color: _titulo),
          ),
        ),
        Expanded(
          child: Slider(
            value: valor.toDouble(),
            min: 0,
            max: max.toDouble(),
            divisions: max,
            activeColor: _laranja,
            onChanged: (v) => aoMudar(v.round()),
          ),
        ),
        SizedBox(
          width: 28,
          child: Text(
            '$valor',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _titulo,
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// RAIZ, GUARD E BLOQUEIO
// =====================================================

/// Decide o que mostrar pelo estado da sessão. A Home só é construída
/// com sessão ativa; não existe rota de Home para abrir direto.
class RaizObjetivos extends StatelessWidget {
  final Widget Function() construirHome;
  const RaizObjetivos({super.key, required this.construirHome});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ControleObjetivos.instance,
      builder: (context, _) {
        switch (ControleObjetivos.instance.estado) {
          case EstadoSessao.ativa:
            return construirHome();
          case EstadoSessao.naoIniciada:
            return const FluxoObjetivosPage();
          case EstadoSessao.expirada:
            return const SizedBox.shrink(); // o SessaoGuard já cobre
        }
      },
    );
  }
}

/// Fica acima do Navigator (MaterialApp.builder). Expirou: o Navigator
/// inteiro (Home, páginas internas, diálogos) sai da árvore e só a tela
/// de bloqueio existe. Também revalida o tempo ao voltar do segundo plano.
class SessaoGuard extends StatefulWidget {
  final Widget child;
  const SessaoGuard({super.key, required this.child});

  @override
  State<SessaoGuard> createState() => _SessaoGuardState();
}

class _SessaoGuardState extends State<SessaoGuard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ControleObjetivos.instance.verificar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ControleObjetivos.instance,
      builder: (context, _) {
        if (ControleObjetivos.instance.estado == EstadoSessao.expirada) {
          return const TelaBloqueio();
        }
        return widget.child;
      },
    );
  }
}

/// Exibida quando a sessão expira. Inclui botão para reiniciar.
class TelaBloqueio extends StatelessWidget {
  const TelaBloqueio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFBEFEA),
                  ),
                  child: const Icon(
                    Icons.hourglass_bottom_rounded,
                    size: 44,
                    color: _laranja,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Seu tempo acabou!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _titulo,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Para utilizar o aplicativo novamente, será necessário '
                  'iniciar uma nova sessão e realizar suas escolhas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: _subtitulo,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
  ControleObjetivos.instance.reiniciarSessao();
  // Depois que o Navigator volta à árvore, limpa toda a pilha
  // e abre a tela de configuração (etapa 1).
  WidgetsBinding.instance.addPostFrameCallback((_) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const FluxoObjetivosPage()),
      (route) => false,
    );
  });
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _laranja,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Iniciar nova sessão',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}

/// Opcional: mostra o tempo restante (ex.: no topo da Home).
class TempoRestante extends StatelessWidget {
  const TempoRestante({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: ControleObjetivos.instance.restante,
      builder: (_, d, __) {
        String dois(int n) => n.toString().padLeft(2, '0');
        return Text(
          '${dois(d.inHours)}:${dois(d.inMinutes % 60)}:${dois(d.inSeconds % 60)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: _laranja,
          ),
        );
      },
    );
  }
}