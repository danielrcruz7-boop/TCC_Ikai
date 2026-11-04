import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikai/tema.dart';
import 'package:ikai/pages_home/perfil/perfil.dart';

import './botoes_configuracao/conta/alterar_informacoes_de_acesso.dart';
import './botoes_configuracao/conta/perfil.dart';

import './botoes_configuracao/ajuda_e_informacoes/ajuda_e_suporte.dart';
import './botoes_configuracao/ajuda_e_informacoes/central_de_ajuda.dart';
import './botoes_configuracao/ajuda_e_informacoes/sobre_ikai.dart';

import './botoes_configuracao/conta_e_sessao/sair_da_conta.dart';
import './botoes_configuracao/conta_e_sessao/excluir_conta.dart';

import './botoes_configuracao/notificao/notificacao.dart';

import './botoes_configuracao/privacidade_e_segurança/privacidade.dart';
import './botoes_configuracao/privacidade_e_segurança/termos_de_uso.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() =>
      _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {

  bool _notificacoes = true;
  bool _lembretesEstudo = true;
  bool _sons = true;
  bool _vibracao = false;

  final AparenciaController _ap = AparenciaController.instancia;

  late double _tamanhoTexto = _ap.tamanhoTexto;

  YkaiCores get c => context.cores;

  String _idioma = 'Português';

  @override
  void initState() {
    super.initState();
    _ap.addListener(_aoMudarAparencia);
  }

  @override
  void dispose() {
    _ap.removeListener(_aoMudarAparencia);
    super.dispose();
  }

  void _aoMudarAparencia() {
    if (mounted) setState(() {});
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.fundo,
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Row(
                children: [
                  IconButton(
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
                      'Configurações',
                      style: GoogleFonts.inter(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: c.texto,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.settings_outlined,
                    color: c.fundo,
                    size: 27,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                children: [
                  Text(
                    'Personalize sua experiência',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: c.textoSecundario,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Tema, alto contraste e tamanho do texto valem para todo '
                    'o aplicativo enquanto ele estiver aberto. As demais '
                    'preferências ainda não são aplicadas nem salvas.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: c.textoSuave,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _tituloSecao(
                    'Conta',
                    Icons.person_outline,
                  ),

                  _cartao([
                    _item(
                      icone: Icons.badge_outlined,
                      titulo: 'Dados pessoais',
                      descricao: 'Gerencie suas informações e altere',
                      aoTocar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DadosPessoaisPage(),
                          ),
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.badge_outlined,
                      titulo: 'Perfil',
                      descricao: 'Modifique o seu perfil',
                      aoTocar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const perfilPage(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // APARÊNCIA
                  _tituloSecao(
                    'Aparência',
                    Icons.palette_outlined,
                  ),

                  _cartao([
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tema do aplicativo',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: c.texto,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Escolha como o Ikai será exibido.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: c.textoSecundario,
                            ),
                          ),

                          const SizedBox(height: 12),

                          RadioGroup<ThemeMode>(
                            groupValue: _ap.tema,
                            onChanged: (valor) {
                              if (valor == null) return;

                              _ap.definirTema(valor);
                            },
                            child: Column(
                              children: [
                                _opcaoTema(
                                  ThemeMode.light,
                                  Icons.light_mode_outlined,
                                  'Claro',
                                ),
                                _opcaoTema(
                                  ThemeMode.dark,
                                  Icons.dark_mode_outlined,
                                  'Escuro',
                                ),
                                _opcaoTema(
                                  ThemeMode.system,
                                  Icons.settings_brightness_outlined,
                                  'Seguir o sistema',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    _divisor(),

                    SwitchListTile(
                      value: _ap.altoContraste,
                      onChanged: (valor) {
                        _ap.definirAltoContraste(valor);
                      },
                      activeTrackColor: c.verde,
                      secondary: Icon(
                        Icons.contrast,
                        color: c.laranja,
                      ),
                      title: Text(
                        'Alto contraste',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: c.texto,
                        ),
                      ),
                      subtitle: const Text(
                        'Melhore a distinção entre elementos',
                      ),
                    ),

                    _divisor(),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tamanho do texto',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: c.texto,
                            ),
                          ),

                          Slider(
                            value: _tamanhoTexto,
                            min: AparenciaController.tamanhoMinimo,
                            max: AparenciaController.tamanhoMaximo,
                            divisions: 6,
                            activeColor: c.verde,
                            label:
                                '${(_tamanhoTexto * 100).round()}%',
                            onChanged: (valor) {
                              setState(() {
                                _tamanhoTexto = valor;
                              });
                            },
                            // Aplica em todo o aplicativo ao soltar o controle.
                            onChangeEnd: _ap.definirTamanhoTexto,
                          ),

                          Text(
                            'Prévia do texto',
                            // Prévia ao vivo enquanto o controle é arrastado.
                            textScaler: TextScaler.linear(
                              AparenciaController.escalaDoSistema(context) *
                                  _tamanhoTexto,
                            ),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: c.texto,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'O tamanho escolhido vale para todo o aplicativo.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: c.textoSuave,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // NOTIFICAÇÕES
                  _tituloSecao(
                    'Notificações',
                    Icons.notifications_none,
                  ),

                  _cartao([
                    _interruptor(
                      icone: Icons.notifications_active_outlined,
                      titulo: 'Notificações',
                      descricao: 'Ativar avisos do aplicativo',
                      valor: _notificacoes,
                      aoAlterar: (valor) {
                        setState(() {
                          _notificacoes = valor;

                          if (!valor) {
                            _lembretesEstudo = false;
                          }
                        });
                      },
                    ),

                    _divisor(),

                    _interruptor(
                      icone: Icons.alarm_outlined,
                      titulo: 'Lembretes de estudo',
                      descricao: 'Receba lembretes para estudar',
                      valor: _lembretesEstudo,
                      aoAlterar: _notificacoes
                          ? (valor) {
                              setState(() {
                                _lembretesEstudo = valor;
                              });
                            }
                          : null,
                    ),

                    _divisor(),

                    _interruptor(
                      icone: Icons.volume_up_outlined,
                      titulo: 'Sons',
                      descricao: 'Sons durante a utilização',
                      valor: _sons,
                      aoAlterar: (valor) {
                        setState(() {
                          _sons = valor;
                        });
                      },
                    ),

                    _divisor(),

                    _interruptor(
                      icone: Icons.vibration,
                      titulo: 'Vibração',
                      descricao: 'Ativar respostas táteis',
                      valor: _vibracao,
                      aoAlterar: (valor) {
                        setState(() {
                          _vibracao = valor;
                        });
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ESTUDOS
                  _tituloSecao(
                    'Preferências de estudo',
                    Icons.school_outlined,
                  ),

                  _cartao([
                    _item(
                      icone: Icons.flag_outlined,
                      titulo: 'Objetivos de aprendizagem',
                      descricao: 'Gerencie suas metas de estudo',
                      aoTocar: () {
                        _mensagem(
                          'A tela de objetivos de aprendizagem ainda não existe '
                          'no projeto.',
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.schedule_outlined,
                      titulo: 'Horários de estudo',
                      descricao: 'Organize sua rotina',
                      aoTocar: () {
                        _mensagem(
                          'A tela de horários de estudo ainda não existe no projeto.',
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // IDIOMA
                  _tituloSecao(
                    'Idioma',
                    Icons.language,
                  ),

                  _cartao([
                    ListTile(
                      leading: Icon(
                        Icons.translate,
                        color: c.laranja,
                      ),
                      title: Text(
                        'Idioma do aplicativo',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.texto,
                        ),
                      ),
                      trailing: DropdownButton<String>(
                        value: _idioma,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'Português',
                            child: Text('Português'),
                          ),
                          DropdownMenuItem(
                            value: 'English',
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: 'Español',
                            child: Text('Español'),
                          ),
                        ],
                        onChanged: (valor) {
                          if (valor == null) return;

                          setState(() {
                            _idioma = valor;
                          });

                          _mensagem(
                            'Idioma selecionado: $_idioma. '
                            'A tradução global precisa ser implementada.',
                          );
                        },
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // PRIVACIDADE
                  _tituloSecao(
                    'Privacidade e segurança',
                    Icons.shield_outlined,
                  ),

                  _cartao([
                    _item(
                      icone: Icons.privacy_tip_outlined,
                      titulo: 'Privacidade',
                      descricao: 'Consulte suas opções de privacidade',
                      aoTocar: () {
                        _abrirDocumento(
                          'Privacidade',
                          'Aqui ficarão as informações sobre '
                          'coleta, uso, armazenamento e proteção '
                          'dos dados dos usuários do Ykai.',
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.description_outlined,
                      titulo: 'Termos de Uso',
                      descricao: 'Leia os termos do aplicativo',
                      aoTocar: () {
                        _abrirDocumento(
                          'Termos de Uso',
                          'Insira aqui o texto oficial dos '
                          'Termos de Uso do Ykai antes de '
                          'publicar o aplicativo.',
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.download_outlined,
                      titulo: 'Meus dados',
                      descricao: 'Informações sobre seus dados',
                      aoTocar: () {
                        _mensagem(
                          'A consulta e exportação dos dados '
                          'precisam ser implementadas.',
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // AJUDA E SOBRE
                  _tituloSecao(
                    'Ajuda e informações',
                    Icons.info_outline,
                  ),

                  _cartao([
                    _item(
                      icone: Icons.help_outline,
                      titulo: 'Central de ajuda',
                      descricao: 'Perguntas frequentes e suporte',
                      aoTocar: () {
                        _abrirDocumento(
                          'Central de ajuda',
                          'Aqui você poderá adicionar perguntas '
                          'frequentes, orientações e informações '
                          'de contato do suporte.',
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.info_outline,
                      titulo: 'Sobre o Ykai',
                      descricao: 'Informações sobre o aplicativo',
                      aoTocar: () {
                        _abrirDocumento(
                          'Sobre o Ykai',
                          'Ykai\n\n'
                          'Aplicativo de aprendizagem.\n'
                          'Versão 1.0.0\n\n'
                          'Adicione aqui os créditos e '
                          'as informações oficiais do projeto.',
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // SESSÃO E CONTA
                  _tituloSecao(
                    'Conta e sessão',
                    Icons.manage_accounts_outlined,
                  ),

                  _cartao([
                    _item(
                      icone: Icons.logout,
                      titulo: 'Sair da conta',
                      descricao: 'Encerrar sua sessão',
                      corIcone: c.laranja,
                      aoTocar: _confirmarSaida,
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.delete_outline,
                      titulo: 'Excluir conta',
                      descricao: 'Solicitar a exclusão da conta',
                      corIcone: c.laranja,
                      aoTocar: _confirmarExclusao,
                    ),
                  ]),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'YKAI • Versão 1.0.0',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: c.textoSuave,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tituloSecao(String titulo, IconData icone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icone,
            color: c.laranja,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: c.texto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartao(List<Widget> filhos) {
    return Container(
      decoration: BoxDecoration(
        color: c.cartao,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: c.borda,
        ),
      ),
      child: Column(
        children: filhos,
      ),
    );
  }

  Widget _divisor() {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: c.borda,
    );
  }

  Widget _item({
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoTocar,
    Color? corIcone,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      leading: Icon(
        icone,
        color: corIcone ?? c.laranja,
        size: 23,
      ),
      title: Text(
        titulo,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c.texto,
        ),
      ),
      subtitle: Text(
        descricao,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: c.textoSecundario,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: c.textoSuave,
      ),
      onTap: aoTocar,
    );
  }

  Widget _interruptor({
    required IconData icone,
    required String titulo,
    required String descricao,
    required bool valor,
    required ValueChanged<bool>? aoAlterar,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      secondary: Icon(
        icone,
        color: c.laranja,
      ),
      title: Text(
        titulo,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c.texto,
        ),
      ),
      subtitle: Text(
        descricao,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: c.textoSecundario,
        ),
      ),
      value: valor,
      activeTrackColor: c.verde,
      onChanged: aoAlterar,
    );
  }

  Widget _opcaoTema(
    ThemeMode modo,
    IconData icone,
    String titulo,
  ) {
    return RadioListTile<ThemeMode>(
      contentPadding: EdgeInsets.zero,
      activeColor: c.verde,
      value: modo,
      title: Row(
        children: [
          Icon(
            icone,
            size: 20,
            color: c.verde,
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: c.texto,
            ),
          ),
        ],
      ),
    );
  }

  void _abrirDocumento(String titulo, String conteudo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: c.fundo,
          appBar: AppBar(
            backgroundColor: c.fundo,
            foregroundColor: c.texto,
            elevation: 0,
            title: Text(
              titulo,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.laranjaClaro,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Conteúdo provisório. Substitua pelo texto oficial '
                    'antes de publicar o aplicativo.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.laranja,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  conteudo,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    height: 1.7,
                    color: c.texto,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarSaida() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Deseja realmente encerrar sua sessão?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      _mensagem(
        'Conecte esta opção ao sistema de autenticação '
        'para encerrar a sessão.',
      );
    }
  }

  Future<void> _confirmarExclusao() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta?'),
        content: const Text(
          'A exclusão de uma conta pode ser permanente e '
          'irreversível. Este aplicativo ainda não está conectado a um '
          'sistema real de contas, então nada será excluído agora.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Continuar',
              style: TextStyle(color: c.laranja),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      _mensagem(
        'A exclusão real precisa ser implementada '
        'com o sistema de contas.',
      );
    }
  }
}