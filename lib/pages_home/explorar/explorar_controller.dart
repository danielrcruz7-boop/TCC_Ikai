import 'package:flutter/foundation.dart';

// Ajuste este caminho se a pasta do Explorar ficar em outro lugar.
import '../../pages_configurar/controle_objetivo.dart';
import 'explorar_fonte.dart';
import 'explorar_model.dart';
import 'explorar_progresso.dart';

enum EstadoFeed { carregando, semPreferencia, erro, pronto }

/// Gerencia o feed do Explorar.
///
/// - Lê objetivo e categoria do `ControleObjetivos` (nunca pergunta de novo).
/// - Acompanha mudanças de preferência sozinho.
/// - Só mantém conteúdos da categoria escolhida (filtra de novo aqui, mesmo
///   que a fonte devolva itens de outras categorias).
/// - NÃO tem cronômetro: o tempo da sessão continua sendo só o do
///   `ControleObjetivos`.
class ExplorarController extends ChangeNotifier {
  ExplorarController({
    FonteDeConteudo? fonte,
    RepositorioProgresso? progresso,
    ControleObjetivos? controle,
  })  : _fonte = fonte ?? FonteCatalogoLocal(),
        _progresso = progresso ?? RepositorioProgresso(),
        _controle = controle ?? ControleObjetivos.instance;

  final FonteDeConteudo _fonte;
  final RepositorioProgresso _progresso;
  final ControleObjetivos _controle;

  EstadoFeed _estado = EstadoFeed.carregando;
  PreferenciaConteudo? _preferencia;
  List<ConteudoExplorar> _conteudos = const [];
  String _consulta = '';
  Object? _erro;

  int _geracao = 0; // descarta respostas de carregamentos antigos
  bool _iniciado = false;
  bool _descartado = false;

  EstadoFeed get estado => _estado;
  PreferenciaConteudo? get preferencia => _preferencia;
  String get consulta => _consulta;
  Object? get erro => _erro;
  bool get semConteudo => _conteudos.isEmpty;
  bool get buscando => normalizarTexto(_consulta).isNotEmpty;

  // ------------------------------------------------------------------
  // Ciclo de vida
  // ------------------------------------------------------------------

  Future<void> iniciar() async {
    if (_iniciado) return;
    _iniciado = true;
    await Future.wait([_controle.carregarPreferencia(), _progresso.carregar()]);
    if (_descartado) return;
    _controle.addListener(_aoMudarControle);
    await _sincronizar();
  }

  @override
  void dispose() {
    _descartado = true;
    _controle.removeListener(_aoMudarControle);
    super.dispose();
  }

  void _aoMudarControle() {
    final nova = _controle.preferenciaConteudo;
    final igual = nova?.objetivo.id == _preferencia?.objetivo.id &&
        nova?.categoria.id == _preferencia?.categoria.id;
    if (!igual) _sincronizar();
  }

  /// Relê a preferência e recarrega o feed. Troca de categoria limpa a pesquisa.
  Future<void> _sincronizar() async {
    if (_descartado) return;
    final nova = _controle.preferenciaConteudo;
    _preferencia = nova;
    _consulta = '';

    if (nova == null) {
      _geracao++;
      _conteudos = const [];
      _erro = null;
      _estado = EstadoFeed.semPreferencia;
      notifyListeners();
      return;
    }

    _estado = EstadoFeed.carregando;
    notifyListeners();
    await _carregar(nova);
  }

  Future<void> _carregar(PreferenciaConteudo pref, {bool forcar = false}) async {
    final g = ++_geracao;
    try {
      final lista = await _fonte.carregar(
        objetivoId: pref.objetivo.id,
        categoriaId: pref.categoria.id,
        forcar: forcar,
      );
      if (_descartado || g != _geracao) return;
      // Defesa extra: nada de outra categoria entra no feed.
      _conteudos = lista
          .where((c) =>
              c.objetivoId == pref.objetivo.id &&
              c.categoriaId == pref.categoria.id)
          .toList(growable: false);
      _erro = null;
      _estado = EstadoFeed.pronto;
    } catch (e) {
      if (_descartado || g != _geracao) return;
      _conteudos = const [];
      _erro = e;
      _estado = EstadoFeed.erro;
    }
    notifyListeners();
  }

  /// Puxar para atualizar.
  Future<void> atualizar() async {
    final pref = _preferencia;
    if (pref == null) {
      await _sincronizar();
      return;
    }
    await _carregar(pref, forcar: true);
  }

  Future<void> tentarNovamente() async {
    if (_descartado) return;
    _estado = EstadoFeed.carregando;
    notifyListeners();
    await atualizar();
  }

  // ------------------------------------------------------------------
  // Pesquisa (sempre dentro da categoria escolhida)
  // ------------------------------------------------------------------

  void buscar(String texto) {
    if (texto == _consulta) return;
    _consulta = texto;
    notifyListeners();
  }

  List<ConteudoExplorar> get resultadosBusca {
    final termos = normalizarTexto(_consulta)
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (termos.isEmpty) return const [];
    return _conteudos
        .where((c) => termos.every((t) => c.textoBusca.contains(t)))
        .toList(growable: false);
  }

  // ------------------------------------------------------------------
  // Seções do feed
  // ------------------------------------------------------------------

  /// Não concluídos primeiro; destaques e ainda não vistos na frente.
  List<ConteudoExplorar> get recomendados {
    final candidatos = <ConteudoExplorar>[];
    for (final c in _conteudos) {
      final p = _progresso.de(c.id);
      if (p == null || !p.concluido) candidatos.add(c);
    }
    int peso(ConteudoExplorar c) =>
        (c.destaque ? 0 : 2) + (_progresso.de(c.id) == null ? 0 : 1);
    final ordem = <String, int>{
      for (var i = 0; i < _conteudos.length; i++) _conteudos[i].id: i,
    };
    candidatos.sort((a, b) {
      final d = peso(a).compareTo(peso(b));
      return d != 0 ? d : ordem[a.id]!.compareTo(ordem[b.id]!);
    });
    return candidatos.take(10).toList(growable: false);
  }

  List<ConteudoExplorar> get curtos => _conteudos
      .where((c) => c.formato == FormatoConteudo.curto)
      .toList(growable: false);

  List<ConteudoExplorar> get aulas => _conteudos
      .where((c) => c.formato == FormatoConteudo.aula)
      .toList(growable: false);

  /// Dicas, materiais e exercícios.
  List<ConteudoExplorar> get outros =>
      _conteudos.where((c) => !c.ehVideo).toList(growable: false);

  /// Vídeos começados e não terminados, do mais recente para o mais antigo.
  List<ConteudoExplorar> get continuarAssistindo {
    final lista = <ConteudoExplorar>[];
    for (final c in _conteudos) {
      final p = _progresso.de(c.id);
      if (c.ehVideo && p != null && p.emAndamento) lista.add(c);
    }
    lista.sort((a, b) => _progresso
        .de(b.id)!
        .ultimoAcesso
        .compareTo(_progresso.de(a.id)!.ultimoAcesso));
    return lista;
  }

  /// Últimos conteúdos acessados da categoria atual (em andamento ou não).
  List<ConteudoExplorar> ultimosAcessados({int limite = 10}) {
    final pref = _preferencia;
    if (pref == null) return const [];
    final porId = {for (final c in _conteudos) c.id: c};
    final lista = <ConteudoExplorar>[];
    for (final p in _progresso.daCategoria(pref.categoria.id)) {
      final c = porId[p.conteudoId];
      if (c != null) lista.add(c);
      if (lista.length >= limite) break;
    }
    return lista;
  }

  // ------------------------------------------------------------------
  // Progresso (usado pelo player)
  // ------------------------------------------------------------------

  ProgressoConteudo? progressoDe(String conteudoId) =>
      _progresso.de(conteudoId);

  /// De onde retomar: só se estiver em andamento; senão, do começo.
  int posicaoParaRetomar(ConteudoExplorar c) {
    final p = _progresso.de(c.id);
    return (p != null && p.emAndamento) ? p.posicaoSegundos : 0;
  }

  /// Registra o progresso. NUNCA chama notifyListeners: o player chama isto
  /// também no dispose, e notificar ali quebraria a árvore de widgets. O feed
  /// se atualiza ao voltar (veja `aoVoltarDoConteudo`).
  void registrarProgresso(
    ConteudoExplorar c, {
    required int posicaoSegundos,
    required int assistidoAdicionalSegundos,
    bool concluido = false,
  }) {
    final agora = DateTime.now();
    final antigo = _progresso.de(c.id);
    _progresso.salvar(
      ProgressoConteudo(
        conteudoId: c.id,
        objetivoId: c.objetivoId,
        categoriaId: c.categoriaId,
        posicaoSegundos: posicaoSegundos,
        duracaoSegundos: c.duracaoSegundos,
        assistidoSegundos:
            (antigo?.assistidoSegundos ?? 0) + assistidoAdicionalSegundos,
        concluido: (antigo?.concluido ?? false) || concluido,
        iniciadoEm: antigo?.iniciadoEm ?? agora,
        ultimoAcesso: agora,
      ),
    );
  }

  /// A tela do Explorar chama isto quando o usuário volta de um conteúdo,
  /// para "Continue assistindo" refletir o progresso novo.
  void aoVoltarDoConteudo() {
    if (!_descartado) notifyListeners();
  }
}