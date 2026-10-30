import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './botoes_configuracao/conta/alterar_informacoes_de_acesso.dart';
import './botoes_configuracao/conta/perfil.dart';

import './botoes_configuracao/ajuda_e_informacoes/ajuda_e_suporte.dart';
import './botoes_configuracao/ajuda_e_informacoes/central_de_ajuda.dart';
import './botoes_configuracao/ajuda_e_informacoes/sobre_ikai.dart';

import './botoes_configuracao/aparencia/aparecia.dart';

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerfilPage(),
                          ),
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.alternate_email,
                      titulo: 'E-mail',
                      descricao: 'Altere seu endereço de e-mail',
                      aoTocar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AlterarInformacoesDeAcessoPage(),
                          ),
                        );
                      },
                    ),

                    _divisor(),

                    _item(
                      icone: Icons.lock_outline,
                      titulo: 'Senha',
                      descricao: 'Altere sua senha de acesso',
                      aoTocar: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AlterarInformacoesDeAcessoPage(),
                          ),
                        );
                      },
                    ),
                  ]
                ),

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