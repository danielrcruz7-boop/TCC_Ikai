import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import './explorar_controller.dart';
import './explorar_estilo.dart';
import './explorar_model.dart';
import './videos_player_page.dart';

/// Tela Explorar: feed personalizado pelo objetivo e categoria da sessão.
///
/// Uso mais simples: `const ExplorarPage()`.
/// - [aoConfigurar]: opcional. Se informado, a mensagem "defina suas
///   preferências" mostra um botão que chama esta função.
/// - [controller]: opcional (para testes ou para compartilhar o estado).
class ExplorarPage extends StatefulWidget {
  const ExplorarPage({super.key, this.controller, this.aoConfigurar});

  final ExplorarController? controller;
  final VoidCallback? aoConfigurar;

  @override
  State<ExplorarPage> createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  late final ExplorarController _c;
  late final bool _donoDoController;
  final TextEditingController _campo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _donoDoController = widget.controller == null;
    _c = widget.controller ?? ExplorarController();
    _c.addListener(_sincronizarCampo);
    _c.iniciar();
  }

  @override
  void dispose() {
    _c.removeListener(_sincronizarCampo);
    if (_donoDoController) _c.dispose();
    _campo.dispose();
    super.dispose();
  }

  /// Se o controller limpou a pesquisa (troca de categoria), limpa o campo.
  void _sincronizarCampo() {
    if (_c.consulta.isEmpty && _campo.text.isNotEmpty) _campo.clear();
  }

  void _limpar() {
    _campo.clear();
    _c.buscar('');
  }

  Future<void> _abrir(ConteudoExplorar c) async {
    FocusScope.of(context).unfocus();
    final categoria = _c.preferencia?.categoria.titulo ?? '';
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => c.ehVideo
            ? VideoPlayerPage(
                conteudo: c,
                controller: _c,
                categoriaTitulo: categoria,
              )
            : LeituraConteudoPage(conteudo: c, categoriaTitulo: categoria),
      ),
    );
    if (mounted) _c.aoVoltarDoConteudo();
  }

  // ------------------------------------------------------------------
  // Estrutura
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EstiloIkai.fundo,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: EstiloIkai.larguraMaxima),
            child: ListenableBuilder(
              listenable: _c,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cabecalho(context),
                  if (_c.estado != EstadoFeed.semPreferencia) _barraBusca(),
                  Expanded(child: _corpo(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecalho(BuildContext context) {
    final pref = _c.preferencia;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        EstiloIkai.margem,
        16,
        EstiloIkai.margem,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (Navigator.of(context).canPop())
                IconButton(
                  tooltip: 'Voltar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40),
                  icon: const Icon(Icons.arrow_back, color: EstiloIkai.titulo),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              const Expanded(
                child: Text(
                  'Explorar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: EstiloIkai.titulo,
                  ),
                ),
              ),

            ],
          ),
          if (pref != null) ...[
            const SizedBox(height: 8),
            RotuloChip(
              texto: '${pref.objetivo.titulo} · ${pref.categoria.titulo}',
              icone: pref.categoria.icone,
              cor: EstiloIkai.laranja,
              fundo: EstiloIkai.laranjaSuave,
            ),
          ],
        ],
      ),
    );
  }

  Widget _barraBusca() {
    const bordaPadrao = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(EstiloIkai.raioCard)),
      borderSide: BorderSide(color: EstiloIkai.borda),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        EstiloIkai.margem,
        0,
        EstiloIkai.margem,
        12,
      ),
      child: TextField(
        controller: _campo,
        textInputAction: TextInputAction.search,
        onChanged: _c.buscar,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        style: const TextStyle(fontSize: 15, color: EstiloIkai.titulo),
        decoration: InputDecoration(
          hintText: 'O que você deseja aprender?',
          hintStyle: const TextStyle(color: EstiloIkai.subtitulo),
          prefixIcon: const Icon(Icons.search, color: EstiloIkai.subtitulo),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _campo,
            builder: (_, v, __) => v.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Limpar pesquisa',
                    icon: const Icon(Icons.close, color: EstiloIkai.subtitulo),
                    onPressed: _limpar,
                  ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: bordaPadrao,
          enabledBorder: bordaPadrao,
          focusedBorder: const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(EstiloIkai.raioCard)),
            borderSide: BorderSide(color: EstiloIkai.laranja, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _corpo(BuildContext context) {
    switch (_c.estado) {
      case EstadoFeed.carregando:
        return const Center(
          child: CircularProgressIndicator(color: EstiloIkai.laranja),
        );

      case EstadoFeed.semPreferencia:
        return MensagemEstado(
          icone: Icons.tune,
          titulo: 'Defina suas preferências',
          texto: 'Escolha um objetivo e uma categoria ao iniciar sua sessão '
              'para ver conteúdos feitos para você.',
          rotuloBotao: widget.aoConfigurar == null
              ? null
              : 'Configurar preferências',
          aoTocar: widget.aoConfigurar,
        );

      case EstadoFeed.erro:
        final detalhe = (kDebugMode && _c.erro != null)
            ? '\n\n(debug) ${_c.erro}'
            : '';
        return MensagemEstado(
          icone: Icons.cloud_off_outlined,
          titulo: 'Não foi possível carregar',
          texto: 'Não conseguimos carregar os conteúdos agora. '
              'Tente novamente.$detalhe',
          rotuloBotao: 'Tentar novamente',
          aoTocar: _c.tentarNovamente,
        );

      case EstadoFeed.pronto:
        if (_c.buscando) return _resultados();
        if (_c.semConteudo) {
          return MensagemEstado(
            icone: Icons.video_library_outlined,
            titulo: 'Ainda não há conteúdos',
            texto: 'Ainda não temos conteúdos de '
                '${_c.preferencia!.categoria.titulo} disponíveis. '
                'Volte em breve!',
            rotuloBotao: 'Atualizar',
            aoTocar: _c.tentarNovamente,
          );
        }
        return _feed();
    }
  }

  // ------------------------------------------------------------------
  // Feed por seções
  // ------------------------------------------------------------------

  Widget _feed() {
    final categoria = _c.preferencia!.categoria.titulo;
    final recomendados = _c.recomendados;
    final curtos = _c.curtos;
    final aulas = _c.aulas;
    final continuar = _c.continuarAssistindo;
    final outros = _c.outros;

    return RefreshIndicator(
      color: EstiloIkai.laranja,
      onRefresh: _c.atualizar,
      child: LayoutBuilder(
        builder: (context, caixa) {
          final larguraCard =
              (caixa.maxWidth * 0.72).clamp(220.0, 300.0).toDouble();
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              if (recomendados.isNotEmpty)
                _secao(
                  'Recomendados para você',
                  _carrossel(context, recomendados, larguraCard, categoria),
                ),
              if (curtos.isNotEmpty)
                _secao(
                  'Vídeos curtos',
                  _carrossel(context, curtos, larguraCard, categoria),
                ),
              if (aulas.isNotEmpty)
                _secao('Aulas completas', _lista(aulas, categoria)),
              if (continuar.isNotEmpty)
                _secao(
                  'Continue assistindo',
                  _carrossel(context, continuar, larguraCard, categoria,
                      mostrarProgresso: true),
                ),
              if (outros.isNotEmpty)
                _secao('Outros conteúdos', _lista(outros, categoria)),
            ],
          );
        },
      ),
    );
  }

  Widget _secao(String titulo, Widget conteudo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: EstiloIkai.margem),
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: EstiloIkai.titulo,
              ),
            ),
          ),
          const SizedBox(height: 12),
          conteudo,
        ],
      ),
    );
  }

  Widget _carrossel(
    BuildContext context,
    List<ConteudoExplorar> itens,
    double larguraCard,
    String categoria, {
    bool mostrarProgresso = false,
  }) {
    // Altura fixa = miniatura 16:9 + área de texto (cresce com o tamanho
    // de texto escolhido pelo usuário).
    final altura = larguraCard * 9 / 16 + 132 * escalaDeTexto(context);
    return SizedBox(
      height: altura,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: EstiloIkai.margem),
        itemCount: itens.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final c = itens[i];
          return SizedBox(
            width: larguraCard,
            child: CardConteudo(
              conteudo: c,
              categoria: categoria,
              progresso: mostrarProgresso ? _c.progressoDe(c.id) : null,
              aoTocar: () => _abrir(c),
            ),
          );
        },
      ),
    );
  }

  Widget _lista(List<ConteudoExplorar> itens, String categoria) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EstiloIkai.margem),
      child: Column(
        children: [
          for (final c in itens)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CardConteudoLinha(
                conteudo: c,
                categoria: categoria,
                aoTocar: () => _abrir(c),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // Resultados da pesquisa
  // ------------------------------------------------------------------

  Widget _resultados() {
    final categoria = _c.preferencia!.categoria.titulo;
    final itens = _c.resultadosBusca;

    if (itens.isEmpty) {
      return MensagemEstado(
        icone: Icons.search_off,
        titulo: 'Nenhum resultado',
        texto: 'Não encontramos conteúdos de $categoria para '
            '“${_c.consulta.trim()}”. Tente outro termo.',
        rotuloBotao: 'Limpar pesquisa',
        aoTocar: _limpar,
      );
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        EstiloIkai.margem,
        4,
        EstiloIkai.margem,
        32,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '${itens.length} ${itens.length == 1 ? 'resultado' : 'resultados'}'
            ' em $categoria',
            style: const TextStyle(fontSize: 13, color: EstiloIkai.subtitulo),
          ),
        ),
        for (final c in itens)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CardConteudoLinha(
              conteudo: c,
              categoria: categoria,
              aoTocar: () => _abrir(c),
            ),
          ),
      ],
    );
  }
}

// =====================================================================
// CARDS
// =====================================================================

IconData _iconeDoTipo(TipoConteudo tipo) {
  switch (tipo) {
    case TipoConteudo.video:
      return Icons.play_circle_outline;
    case TipoConteudo.dica:
      return Icons.lightbulb_outline;
    case TipoConteudo.material:
      return Icons.description_outlined;
    case TipoConteudo.exercicio:
      return Icons.assignment_outlined;
  }
}

/// Miniatura 16:9 com selo de formato, duração e barra de progresso.
class Miniatura extends StatelessWidget {
  final ConteudoExplorar conteudo;
  final ProgressoConteudo? progresso;
  final bool compacta;

  const Miniatura({
    super.key,
    required this.conteudo,
    this.progresso,
    this.compacta = false,
  });

  Widget _placeholder() => Container(
        color: EstiloIkai.superficieSuave,
        alignment: Alignment.center,
        child: Icon(
          _iconeDoTipo(conteudo.tipo),
          size: 40,
          color: EstiloIkai.laranja.withValues(alpha: 0.6),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final url = conteudo.miniaturaEfetiva;
    final p = progresso;
    final duracao = conteudo.duracaoSegundos;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url == null)
            _placeholder()
          else
            Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
              loadingBuilder: (_, filho, carregando) =>
                  carregando == null ? filho : _placeholder(),
            ),
          if (!compacta)
            Positioned(
              left: 8,
              top: 8,
              child: _SeloSobreImagem(conteudo.rotuloFormato),
            ),
          if (duracao != null)
            Positioned(
              right: 8,
              bottom: p != null && p.fracao > 0 ? 12 : 8,
              child: _SeloSobreImagem(formatarRelogio(duracao)),
            ),
          if (p != null && p.fracao > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LinearProgressIndicator(
                value: p.fracao,
                minHeight: 4,
                backgroundColor: Colors.black26,
                color: EstiloIkai.laranja,
              ),
            ),
        ],
      ),
    );
  }
}

class _SeloSobreImagem extends StatelessWidget {
  final String texto;
  const _SeloSobreImagem(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Card vertical, usado nos carrosséis. Precisa de altura definida pelo pai.
class CardConteudo extends StatelessWidget {
  final ConteudoExplorar conteudo;
  final String categoria;
  final ProgressoConteudo? progresso;
  final VoidCallback aoTocar;

  const CardConteudo({
    super.key,
    required this.conteudo,
    required this.categoria,
    required this.aoTocar,
    this.progresso,
  });

  @override
  Widget build(BuildContext context) {
    final fonte = conteudo.fonteNome;
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EstiloIkai.raioCard),
        side: const BorderSide(color: EstiloIkai.borda),
      ),
      child: InkWell(
        onTap: aoTocar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Miniatura(conteudo: conteudo, progresso: progresso),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conteudo.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: EstiloIkai.titulo,
                      ),
                    ),
                    if (conteudo.descricao.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        conteudo.descricao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: EstiloIkai.subtitulo,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      fonte == null ? categoria : '$categoria · $fonte',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: EstiloIkai.subtitulo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card em linha, usado em listas e nos resultados da pesquisa.
class CardConteudoLinha extends StatelessWidget {
  final ConteudoExplorar conteudo;
  final String categoria;
  final VoidCallback aoTocar;

  const CardConteudoLinha({
    super.key,
    required this.conteudo,
    required this.categoria,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final fonte = conteudo.fonteNome;
    final Widget inicio = conteudo.ehVideo
        ? SizedBox(
            width: 132,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Miniatura(conteudo: conteudo, compacta: true),
            ),
          )
        : Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: EstiloIkai.superficieSuave,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconeDoTipo(conteudo.tipo),
              color: EstiloIkai.laranja,
              size: 26,
            ),
          );

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EstiloIkai.raioCard),
        side: const BorderSide(color: EstiloIkai.borda),
      ),
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inicio,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conteudo.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: EstiloIkai.titulo,
                      ),
                    ),
                    if (conteudo.descricao.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        conteudo.descricao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: EstiloIkai.subtitulo,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        RotuloChip(
                          texto: conteudo.rotuloFormato,
                          icone: _iconeDoTipo(conteudo.tipo),
                          cor: EstiloIkai.laranja,
                          fundo: EstiloIkai.laranjaSuave,
                        ),
                        RotuloChip(texto: categoria),
                      ],
                    ),
                    if (fonte != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        fonte,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: EstiloIkai.subtitulo,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// LEITURA (dicas, materiais e exercícios)
// =====================================================================

/// Mostra conteúdos sem vídeo. Fica dentro do Navigator do app, então o
/// `SessaoGuard` também a cobre quando o tempo acaba.
class LeituraConteudoPage extends StatelessWidget {
  final ConteudoExplorar conteudo;
  final String categoriaTitulo;

  const LeituraConteudoPage({
    super.key,
    required this.conteudo,
    required this.categoriaTitulo,
  });

  @override
  Widget build(BuildContext context) {
    final fonte = conteudo.fonteNome;
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
                BarraTopoConteudo(titulo: categoriaTitulo),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      EstiloIkai.margem,
                      8,
                      EstiloIkai.margem,
                      32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            RotuloChip(
                              texto: conteudo.rotuloFormato,
                              icone: _iconeDoTipo(conteudo.tipo),
                              cor: EstiloIkai.laranja,
                              fundo: EstiloIkai.laranjaSuave,
                            ),
                            RotuloChip(texto: categoriaTitulo),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          conteudo.titulo,
                          style: const TextStyle(
                            fontSize: 24,
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
                        const SizedBox(height: 20),
                        SelectableText(
                          conteudo.corpo ?? conteudo.descricao,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: EstiloIkai.titulo,
                          ),
                        ),
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
}