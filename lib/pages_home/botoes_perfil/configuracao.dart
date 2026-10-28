import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() =>
      _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  static const Color _fundo = Color(0xFFFDFBF7);
  static const Color _laranja = Color(0xFFCB5A34);
  static const Color _texto = Color(0xFF243044);
  static const Color _verde = Color(0xFF4B7F5A);

  ThemeMode _tema = ThemeMode.light;

  bool _notificacoes = true;
  bool _lembretesEstudo = true;
  bool _sons = true;
  bool _vibracao = false;
  bool _altoContraste = false;

  double _tamanhoTexto = 1.0;

  String _idioma = 'Português';

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
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
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: _texto,
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
                        color: _texto,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.settings_outlined,
                    color: _fundo,
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
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'As preferências abaixo ainda não são aplicadas a todo '
                    'o aplicativo nem salvas permanentemente.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // CONTA
                  _tituloSecao(
                    'Conta',
                    Icons.person_outline,
                  ),

                  _cartao([
                    _item(
                      icone: Icons.badge_outlined,
                      titulo: 'Dados pessoais',
                      descricao: 'Gerencie suas informações',
                      aoTocar: () {
                        _mensagem(
                          'Por enquanto, edite nome e e-mail em Perfil > Meu perfil. '
                          'A alteração real da conta depende do sistema de contas.',
                        );
                      },
                    ),
                    _divisor(),
                    _item(
                      icone: Icons.alternate_email,
                      titulo: 'E-mail',
                      descricao: 'Altere seu endereço de e-mail',
                      aoTocar: () {
                        _mensagem(
                          'A alteração real do e-mail depende do sistema de contas. '
                          'Por enquanto, use Perfil > Meu perfil.',
                        );
                      },
                    ),
                    _divisor(),
                    _item(
                      icone: Icons.lock_outline,
                      titulo: 'Senha',
                      descricao: 'Altere sua senha de acesso',
                      aoTocar: () {
                        _mensagem(
                          'A alteração de senha depende do sistema de autenticação, '
                          'que ainda não foi conectado.',
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
                              color: _texto,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Escolha como o Ykai será exibido.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          RadioGroup<ThemeMode>(
                            groupValue: _tema,
                            onChanged: (valor) {
                              if (valor == null) return;

                              setState(() {
                                _tema = valor;
                              });

                              _mensagem(
                                'Preferência de tema alterada. '
                                'Para mudar todo o aplicativo, '
                                'conecte essa opção ao tema global.',
                              );
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
                      value: _altoContraste,
                      onChanged: (valor) {
                        setState(() {
                          _altoContraste = valor;
                        });

                        _mensagem(
                          'Alto contraste ainda não altera o restante '
                          'do aplicativo.',
                        );
                      },
                      activeTrackColor: _verde,
                      secondary: const Icon(
                        Icons.contrast,
                        color: _laranja,
                      ),
                      title: Text(
                        'Alto contraste',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: _texto,
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
                              color: _texto,
                            ),
                          ),

                          Slider(
                            value: _tamanhoTexto,
                            min: 0.8,
                            max: 1.4,
                            divisions: 6,
                            activeColor: _verde,
                            label:
                                '${(_tamanhoTexto * 100).round()}%',
                            onChanged: (valor) {
                              setState(() {
                                _tamanhoTexto = valor;
                              });
                            },
                          ),

                          Text(
                            'Prévia do texto',
                            style: GoogleFonts.inter(
                              fontSize: 14 * _tamanhoTexto,
                              color: _texto,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'O tamanho escolhido afeta apenas esta prévia.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.grey.shade500,
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
                      leading: const Icon(
                        Icons.translate,
                        color: _laranja,
                      ),
                      title: Text(
                        'Idioma do aplicativo',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _texto,
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
                      corIcone: _laranja,
                      aoTocar: _confirmarSaida,
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.delete_outline,
                      titulo: 'Excluir conta',
                      descricao: 'Solicitar a exclusão da conta',
                      corIcone: _laranja,
                      aoTocar: _confirmarExclusao,
                    ),
                  ]),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'YKAI • Versão 1.0.0',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
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
            color: _laranja,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _texto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartao(List<Widget> filhos) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF0ECE6),
        ),
      ),
      child: Column(
        children: filhos,
      ),
    );
  }

  Widget _divisor() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF0ECE6),
    );
  }

  Widget _item({
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoTocar,
    Color corIcone = _laranja,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      leading: Icon(
        icone,
        color: corIcone,
        size: 23,
      ),
      title: Text(
        titulo,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _texto,
        ),
      ),
      subtitle: Text(
        descricao,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
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
        color: _laranja,
      ),
      title: Text(
        titulo,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _texto,
        ),
      ),
      subtitle: Text(
        descricao,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      value: valor,
      activeTrackColor: _verde,
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
      value: modo,
      title: Row(
        children: [
          Icon(
            icone,
            size: 20,
            color: _verde,
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: _texto,
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
          backgroundColor: _fundo,
          appBar: AppBar(
            backgroundColor: _fundo,
            foregroundColor: _texto,
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
                    color: const Color(0xFFFBEFEA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Conteúdo provisório. Substitua pelo texto oficial '
                    'antes de publicar o aplicativo.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _laranja,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  conteudo,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    height: 1.7,
                    color: _texto,
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
            child: const Text(
              'Continuar',
              style: TextStyle(color: _laranja),
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