import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikai/tema.dart';

// =====================================================
// TELA DE NOTIFICAÇÕES
//
// Arquivo: lib/pages_home/home/notificacao.dart
// Aberta pela Home com: const notificacaoPage()
//
// ATENÇÃO: as notificações abaixo são DEMONSTRATIVAS e ficam apenas em
// memória. O aplicativo ainda não possui integração com notificações reais
// (push, backend ou banco de dados). Quando existir, substitua a lista
// `_itens` pelos dados reais.
// =====================================================

enum _TipoNotificacao { lembrete, conquista, comunidade, sistema }

class _Notificacao {
  final int id;
  final String grupo; // "Hoje", "Ontem", "Anteriores"
  final _TipoNotificacao tipo;
  final String titulo;
  final String descricao;
  final String tempo; // texto fixo de exemplo
  bool lida;

  _Notificacao({
    required this.id,
    required this.grupo,
    required this.tipo,
    required this.titulo,
    required this.descricao,
    required this.tempo,
    this.lida = false,
  });
}

/// Guarda as notificações em MEMÓRIA, fora da tela.
///
/// Por que existe: a tela é recriada toda vez que o usuário entra nela. Se a
/// lista ficasse dentro do State, tudo voltaria a "não lido" a cada visita.
/// Aqui, o que foi lido ou removido continua assim enquanto o aplicativo
/// estiver aberto.
///
/// ATENÇÃO: não há persistência. Ao fechar o aplicativo, a lista volta ao
/// estado inicial. Para manter entre execuções, salve em armazenamento
/// permanente (ex.: shared_preferences) ou use as notificações reais.
class _RepositorioNotificacoes {
  _RepositorioNotificacoes._();

  // Dados demonstrativos (veja o aviso no topo do arquivo).
  static final List<_Notificacao> itens = [
    _Notificacao(
      id: 1,
      grupo: 'Hoje',
      tipo: _TipoNotificacao.lembrete,
      titulo: 'Hora de respirar',
      descricao: 'Que tal 10 minutos de respiração para cultivar calma?',
      tempo: 'Há 20 min',
    ),
    _Notificacao(
      id: 2,
      grupo: 'Hoje',
      tipo: _TipoNotificacao.lembrete,
      titulo: 'Meta de hidratação',
      descricao: 'Você bebeu 4 de 8 copos de água hoje. Continue assim!',
      tempo: 'Há 2 h',
    ),
    _Notificacao(
      id: 3,
      grupo: 'Ontem',
      tipo: _TipoNotificacao.conquista,
      titulo: 'Nova conquista',
      descricao: 'Você completou 7 dias seguidos de meditação.',
      tempo: 'Ontem, 20:15',
    ),
    _Notificacao(
      id: 4,
      grupo: 'Ontem',
      tipo: _TipoNotificacao.comunidade,
      titulo: 'Atividade na comunidade',
      descricao: 'Sua publicação recebeu novas respostas.',
      tempo: 'Ontem, 14:02',
      lida: true,
    ),
    _Notificacao(
      id: 5,
      grupo: 'Anteriores',
      tipo: _TipoNotificacao.sistema,
      titulo: 'Resumo semanal',
      descricao: 'O resumo do seu progresso da semana está disponível.',
      tempo: 'Segunda, 08:00',
      lida: true,
    ),
    _Notificacao(
      id: 6,
      grupo: 'Anteriores',
      tipo: _TipoNotificacao.sistema,
      titulo: 'Boas-vindas ao Ikai',
      descricao: 'Explore as práticas rápidas e comece pelo que faz sentido '
          'para você.',
      tempo: 'Há 3 dias',
      lida: true,
    ),
  ];
}

class notificacaoPage extends StatefulWidget {
  const notificacaoPage({super.key});

  @override
  State<notificacaoPage> createState() => _notificacaoPageState();
}

class _notificacaoPageState extends State<notificacaoPage> {
  YkaiCores get c => context.cores;

  bool _somenteNaoLidas = false;

  List<_Notificacao> get _itens => _RepositorioNotificacoes.itens;

  int get _quantidadeNaoLidas => _itens.where((n) => !n.lida).length;

  List<_Notificacao> get _visiveis => _itens
      .where((n) => !_somenteNaoLidas || !n.lida)
      .toList();

  void _marcarComoLida(_Notificacao n) {
    if (n.lida) return;
    setState(() => n.lida = true);
  }

  void _marcarTodasComoLidas() {
    setState(() {
      for (final n in _itens) {
        n.lida = true;
      }
    });
  }

  void _remover(_Notificacao n) {
    final indice = _itens.indexOf(n);
    if (indice < 0) return;

    setState(() => _itens.removeAt(indice));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Notificação removida'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              if (!mounted) return;
              setState(() {
                final posicao =
                    indice > _itens.length ? _itens.length : indice;
                _itens.insert(posicao, n);
              });
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final naoLidas = _quantidadeNaoLidas;
    final visiveis = _visiveis;

    return Scaffold(
      backgroundColor: c.fundo,
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // CABEÇALHO
            // =========================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Voltar',
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: c.texto,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Notificações',
                      style: GoogleFonts.inter(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: c.texto,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 42,
                    height: 42,
                    child: Tooltip(
                      message: 'Marcar todas como lidas',
                      child: ElevatedButton(
                        onPressed:
                            naoLidas > 0 ? _marcarTodasComoLidas : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.verdeClaro,
                          foregroundColor: c.verde,
                          disabledBackgroundColor: c.borda,
                          disabledForegroundColor: c.textoSuave,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(
                          Icons.done_all_rounded,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  naoLidas == 0
                      ? 'Você está em dia'
                      : naoLidas == 1
                          ? 'Você tem 1 notificação não lida'
                          : 'Você tem $naoLidas notificações não lidas',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: c.textoSecundario,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // FILTROS
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _filtro(
                      rotulo: 'Todas',
                      selecionado: !_somenteNaoLidas,
                      aoSelecionar: () =>
                          setState(() => _somenteNaoLidas = false),
                    ),
                    _filtro(
                      rotulo: 'Não lidas ($naoLidas)',
                      selecionado: _somenteNaoLidas,
                      aoSelecionar: () =>
                          setState(() => _somenteNaoLidas = true),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // =========================
            // LISTA
            // =========================
            Expanded(
              child: visiveis.isEmpty
                  ? _estadoVazio()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                      itemCount: visiveis.length + 1,
                      itemBuilder: (context, indice) {
                        if (indice == visiveis.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Notificações de exemplo. Ainda não estão '
                              'conectadas a avisos reais.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: c.textoSuave,
                              ),
                            ),
                          );
                        }

                        final n = visiveis[indice];
                        final mostrarGrupo = indice == 0 ||
                            visiveis[indice - 1].grupo != n.grupo;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (mostrarGrupo)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: indice == 0 ? 8 : 16,
                                  bottom: 10,
                                ),
                                child: Text(
                                  n.grupo,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: c.texto,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _itemDispensavel(n),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------
  // COMPONENTES
  // -----------------------------------------------------

  Widget _filtro({
    required String rotulo,
    required bool selecionado,
    required VoidCallback aoSelecionar,
  }) {
    return ChoiceChip(
      label: Text(
        rotulo,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selecionado ? Colors.white : c.texto,
        ),
      ),
      selected: selecionado,
      showCheckmark: false,
      selectedColor: c.laranja,
      backgroundColor: c.cartao,
      side: BorderSide(
        color: selecionado ? c.laranja : c.borda,
      ),
      shape: const StadiumBorder(),
      onSelected: (_) => aoSelecionar(),
    );
  }

  Widget _itemDispensavel(_Notificacao n) {
    final fundoAcao = Container(
      alignment: Alignment.center,
      color: c.laranja,
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 24,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Dismissible(
        key: ValueKey(n.id),
        background: fundoAcao,
        secondaryBackground: fundoAcao,
        onDismissed: (_) => _remover(n),
        child: _CartaoNotificacao(
          notificacao: n,
          aoTocar: () => _marcarComoLida(n),
        ),
      ),
    );
  }

  Widget _estadoVazio() {
    final filtrando = _somenteNaoLidas && _itens.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: c.laranjaClaro,
                shape: BoxShape.circle,
              ),
              child: Icon(
                filtrando
                    ? Icons.check_circle_outline
                    : Icons.notifications_none_rounded,
                color: c.laranja,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              filtrando ? 'Tudo lido por aqui' : 'Nenhuma notificação',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: c.texto,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              filtrando
                  ? 'Você não tem notificações não lidas.'
                  : 'Quando houver novidades, elas aparecerão aqui.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: c.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// CARTÃO DE NOTIFICAÇÃO
// =====================================================

class _CartaoNotificacao extends StatelessWidget {
  final _Notificacao notificacao;
  final VoidCallback aoTocar;

  const _CartaoNotificacao({
    required this.notificacao,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.cores;
    final n = notificacao;

    final IconData icone;
    final Color fundoIcone;
    final Color corIcone;

    switch (n.tipo) {
      case _TipoNotificacao.lembrete:
        icone = Icons.alarm_outlined;
        fundoIcone = c.laranjaClaro;
        corIcone = c.laranja;
        break;
      case _TipoNotificacao.conquista:
        icone = Icons.emoji_events_outlined;
        fundoIcone = c.verdeClaro;
        corIcone = c.verde;
        break;
      case _TipoNotificacao.comunidade:
        icone = Icons.people_outline;
        fundoIcone = c.verdeClaro;
        corIcone = c.verde;
        break;
      case _TipoNotificacao.sistema:
        icone = Icons.info_outline;
        fundoIcone = c.borda;
        corIcone = c.textoSecundario;
        break;
    }

    return Material(
      color: c.cartao,
      child: InkWell(
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.borda),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: fundoIcone,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: corIcone, size: 23),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.titulo,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight:
                                  n.lida ? FontWeight.w600 : FontWeight.bold,
                              color: c.texto,
                            ),
                          ),
                        ),
                        if (!n.lida) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: c.laranja,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 3),

                    Text(
                      n.descricao,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.4,
                        color: c.textoSecundario,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      n.tempo,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: c.textoSuave,
                      ),
                    ),
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