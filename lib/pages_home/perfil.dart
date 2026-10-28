import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './botoes_perfil/configuracao.dart';

/// Dados exibidos no Perfil.
class DadosPerfil {
  final String nome;
  final String email;

  const DadosPerfil({
    required this.nome,
    required this.email,
  });
}

/// Guarda em MEMÓRIA os dados editados pelo usuário.
///
/// Por que existe: a Home troca entre o conteúdo da aba "Home" e o
/// `IndexedStack`, e isso descarta o estado do `PerfilPage` ao voltar
/// para a primeira aba. Guardar aqui evita perder o nome/e-mail editado
/// ao trocar de aba.
///
/// ATENÇÃO: não há persistência. Ao fechar o aplicativo os dados voltam
/// aos valores originais. Substitua por armazenamento permanente
/// (ex.: shared_preferences) ou pelo sistema de contas quando existir.
class PerfilSessao {
  PerfilSessao._();

  static final ValueNotifier<DadosPerfil?> dados =
      ValueNotifier<DadosPerfil?>(null);
}

class PerfilPage extends StatefulWidget {
  final String nome;
  final String email;

  const PerfilPage({
    super.key,
    this.nome = 'Nome do usuário',
    this.email = 'email@exemplo.com',
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  static const Color _fundo = Color(0xFFFDFBF7);
  static const Color _laranja = Color(0xFFCB5A34);
  static const Color _texto = Color(0xFF243044);
  static const Color _verde = Color(0xFF4B7F5A);
  static const Color _verdeClaro = Color(0xFFEAF2EC);

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  void configuracao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfiguracoesPage(),
      ),
    );
  }

  Future<void> _abrirEdicao(DadosPerfil atuais) async {
    final resultado = await Navigator.push<DadosPerfil>(
      context,
      MaterialPageRoute(
        builder: (context) => _EditarPerfilPage(
          nomeInicial: atuais.nome,
          emailInicial: atuais.email,
        ),
      ),
    );

    if (resultado == null || !mounted) return;

    PerfilSessao.dados.value = resultado;

    _mensagem(
      'Dados atualizados apenas enquanto o aplicativo estiver aberto.',
    );
  }

  void _abrirAjuda() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _AjudaSuportePage(),
      ),
    );
  }

  Future<void> _confirmarSaida() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Sair',
              style: TextStyle(color: _laranja),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      // O projeto ainda não possui sistema de autenticação.
      // Nenhuma sessão é encerrada e nenhum dado é apagado.
      _mensagem(
        'A saída da conta ainda precisa ser conectada ao sistema de '
        'autenticação. Nenhum dado foi apagado.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ValueListenableBuilder<DadosPerfil?>(
            valueListenable: PerfilSessao.dados,
            builder: (context, editados, _) {
              final dados = editados ??
                  DadosPerfil(nome: widget.nome, email: widget.email);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perfil',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _texto,
                        ),
                      ),
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: Tooltip(
                          message: 'Configurações',
                          child: ElevatedButton(
                            onPressed: () => configuracao(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _verdeClaro,
                              foregroundColor: _verde,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // Avatar
                  const Center(
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFFF6E5DC),
                      child: Icon(
                        Icons.person_outline,
                        size: 56,
                        color: _laranja,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nome
                  Center(
                    child: Text(
                      dados.nome,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: _texto,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // E-mail
                  Center(
                    child: Text(
                      dados.email,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Meu perfil
                  _CartaoNavegacao(
                    icone: Icons.badge_outlined,
                    titulo: 'Meu perfil',
                    descricao: 'Visualize e edite seu nome e e-mail',
                    aoTocar: () => _abrirEdicao(dados),
                  ),

                  const SizedBox(height: 12),

                  // Ajuda e suporte
                  _CartaoNavegacao(
                    icone: Icons.help_outline,
                    titulo: 'Ajuda e suporte',
                    descricao: 'Dúvidas e canais de atendimento',
                    aoTocar: _abrirAjuda,
                  ),

                  const SizedBox(height: 32),

                  // Sair da conta
                  OutlinedButton.icon(
                    onPressed: _confirmarSaida,
                    icon: const Icon(Icons.logout, size: 20),
                    label: Text(
                      'Sair da conta',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _laranja,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: _laranja),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CARTÃO DE NAVEGAÇÃO (padrão visual de Configurações)
// =====================================================

class _CartaoNavegacao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback aoTocar;

  const _CartaoNavegacao({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.aoTocar,
  });

  static const Color _laranja = Color(0xFFCB5A34);
  static const Color _texto = Color(0xFF243044);
  static const Color _borda = Color(0xFFF0ECE6);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: aoTocar,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _borda),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEFEA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icone, color: _laranja, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _texto,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      descricao,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// EDIÇÃO DO PERFIL
// =====================================================

class _EditarPerfilPage extends StatefulWidget {
  final String nomeInicial;
  final String emailInicial;

  const _EditarPerfilPage({
    required this.nomeInicial,
    required this.emailInicial,
  });

  @override
  State<_EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<_EditarPerfilPage> {
  static const Color _fundo = Color(0xFFFDFBF7);
  static const Color _laranja = Color(0xFFCB5A34);
  static const Color _texto = Color(0xFF243044);
  static const Color _borda = Color(0xFFF0ECE6);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nome =
      TextEditingController(text: widget.nomeInicial);
  late final TextEditingController _email =
      TextEditingController(text: widget.emailInicial);

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _validarNome(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Informe seu nome.';
    if (texto.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres.';
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Informe seu e-mail.';
    final valido = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(texto);
    if (!valido) return 'Informe um e-mail válido.';
    return null;
  }

  void _salvar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.pop(
      context,
      DadosPerfil(
        nome: _nome.text.trim(),
        email: _email.text.trim(),
      ),
    );
  }

  InputDecoration _decoracao(String rotulo, IconData icone) {
    OutlineInputBorder borda(Color cor, [double largura = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cor, width: largura),
      );
    }

    return InputDecoration(
      labelText: rotulo,
      labelStyle: GoogleFonts.inter(fontSize: 14),
      prefixIcon: Icon(icone, color: _laranja),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: borda(_borda),
      focusedBorder: borda(_laranja, 1.5),
      errorBorder: borda(Colors.red.shade400),
      focusedErrorBorder: borda(Colors.red.shade400, 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      appBar: AppBar(
        backgroundColor: _fundo,
        foregroundColor: _texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Meu perfil',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2EC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF4B7F5A),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'As alterações valem apenas enquanto o aplicativo '
                          'estiver aberto. Ainda não há armazenamento '
                          'permanente nem sistema de contas conectado.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: _texto,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nome,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validarNome,
                  style: GoogleFonts.inter(fontSize: 15, color: _texto),
                  decoration: _decoracao('Nome', Icons.person_outline),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validarEmail,
                  onFieldSubmitted: (_) => _salvar(),
                  style: GoogleFonts.inter(fontSize: 15, color: _texto),
                  decoration:
                      _decoracao('E-mail', Icons.alternate_email),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _laranja,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Salvar alterações',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

// =====================================================
// AJUDA E SUPORTE
// =====================================================

class _AjudaSuportePage extends StatelessWidget {
  const _AjudaSuportePage();

  static const Color _fundo = Color(0xFFFDFBF7);
  static const Color _texto = Color(0xFF243044);

  static const String _centralAjuda = '''CENTRAL DE AJUDA DO IKAI

Bem-vindo à Central de Ajuda do Ikai! Nosso objetivo é proporcionar uma experiência digital mais consciente, incentivando o aprendizado e o uso saudável da tecnologia.

O que é o Ikai?
O Ikai é um aplicativo de aprendizagem e uma rede social que busca oferecer conteúdos de forma consciente, com feed finito e controle de tempo.

Tipos de conteúdo
O aplicativo contempla três formatos principais: artigos, vídeos educativos e vídeos low dopamine, que apresentam uma proposta mais tranquila de conteúdo.

Feed e limite de tempo
O Ikai foi pensado para evitar a rolagem infinita e permitir que o usuário defina o tempo de cada sessão, incentivando escolhas conscientes sobre o uso do aplicativo.

Personalização e biblioteca
A proposta é permitir a escolha de interesses e filtros de conteúdo, além de oferecer uma biblioteca pessoal para guardar referências e consultar materiais posteriormente.

Metas e notificações
O aplicativo prevê metas e conquistas voltadas ao progresso individual, sem foco em rankings competitivos, e busca evitar notificações insistentes.

Privacidade e segurança
O projeto prioriza a privacidade, evita solicitar informações desnecessárias e prevê proteção das conversas por criptografia de ponta a ponta. A disponibilidade dessas proteções depende da implementação efetiva.

Dados e conta
Estão previstos recursos para exportar dados e solicitar a exclusão da conta, conforme a implementação do sistema.

Problemas e sugestões
Em caso de erros, recomenda-se reiniciar o aplicativo, verificar atualizações e registrar o ocorrido. Os usuários também podem enviar sugestões pelos canais disponibilizados.

Denúncias e suporte
Publicações inadequadas podem ser denunciadas caso o recurso esteja disponível. Se precisar de mais ajuda, procure o canal oficial de suporte do Ikai.

Ikai — Aprenda, descubra e aproveite seu tempo com mais consciência.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      appBar: AppBar(
        backgroundColor: _fundo,
        foregroundColor: _texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Ajuda e suporte',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Text(
            _centralAjuda,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.7,
              color: _texto,
            ),
          ),
        ),
      ),
    );
  }
}
