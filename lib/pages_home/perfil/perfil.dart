import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ikai/pages_home/perfil/botoes_configuracao/aparencia/aparencia.dart';
import './configuracao.dart';

/// Dados exibidos no Perfil.
class DadosPerfil {
  final String nome;
  final String email;

  const DadosPerfil({
    required this.nome,
    required this.email,
  });
}


class PerfilSessao {
  PerfilSessao._();

  static final ValueNotifier<DadosPerfil?> dados =
      ValueNotifier<DadosPerfil?>(null);


  static final ValueNotifier<Uint8List?> foto =
      ValueNotifier<Uint8List?>(null);

  static Future<void> selecionarFoto() async {
    try {
      final imagem = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1200,
      );

      if (imagem == null) return;

      final bytes = await imagem.readAsBytes();

      if (bytes.isNotEmpty) {
        foto.value = bytes;
      }
    } catch (_) {}
  }
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
  YkaiCores get c => context.cores;

  @override
  void initState() {
    super.initState();
    _recuperarFotoSelecionada();
  }

  // No Android, o sistema pode encerrar a atividade enquanto a galeria
  // está aberta. Este método recupera a imagem escolhida nesse cenário.
  Future<void> _recuperarFotoSelecionada() async {
    try {
      final resposta = await ImagePicker().retrieveLostData();
      if (resposta.isEmpty || resposta.files == null ||
          resposta.files!.isEmpty) {
        return;
      }

      final bytes = await resposta.files!.first.readAsBytes();
      if (bytes.isNotEmpty) {
        PerfilSessao.foto.value = bytes;
      }
    } catch (_) {
      // Se não houver imagem perdida, o perfil continua funcionando normalmente.
    }
  }

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

  Future<void> _selecionarFoto() async {
    try {
      final imagem = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1200,
      );

      if (imagem == null) return;

      // Lê a imagem inteira para a memória.
      final bytes = await imagem.readAsBytes();

      if (bytes.isEmpty) {
        if (mounted) {
          _mensagem('Não foi possível carregar a imagem escolhida.');
        }
        return;
      }

      // Atualiza o perfil mesmo se o Android tiver reconstruído a tela.
      PerfilSessao.foto.value = bytes;

      if (mounted) {
        _mensagem('Foto de perfil atualizada.');
      }
    } catch (erro) {
      if (mounted) {
        _mensagem('Não foi possível carregar a foto. Tente escolher outra imagem.');
      }
    }
  }

  void _abrirAreaPostagens() {
    _mensagem('A área de postagens será disponibilizada em uma próxima etapa.');
  }

  void _compartilharPerfil(DadosPerfil dados) {
    final usuario = '@${dados.nome.toLowerCase().replaceAll(' ', '')}';

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Compartilhar perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Compartilhe seu perfil do IKAI com outras pessoas.'),
            const SizedBox(height: 12),
            SelectableText(
              usuario,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: c.laranja,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O compartilhamento externo poderá ser conectado em uma próxima etapa.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: ValueListenableBuilder<DadosPerfil?>(
            valueListenable: PerfilSessao.dados,
            builder: (context, editados, _) {
              final dados = editados ??
                  DadosPerfil(nome: widget.nome, email: widget.email);
              final usuario = dados.nome
                  .trim()
                  .toLowerCase()
                  .replaceAll(RegExp(r'\s+'), '');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho: título e botão original de configurações.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perfil',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: c.texto,
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
                              backgroundColor: c.verdeClaro,
                              foregroundColor: c.verde,
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
                  const SizedBox(height: 28),

                  // Foto centralizada, com acesso à galeria do dispositivo.
                  Center(
                    child: ValueListenableBuilder<Uint8List?>(
                      valueListenable: PerfilSessao.foto,
                      builder: (context, bytesFoto, _) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: _selecionarFoto,
                              child: ClipOval(
                                child: Container(
                                  width: 116,
                                  height: 116,
                                  color: c.laranjaClaro,
                                  child: bytesFoto == null
                                      ? Icon(
                                          Icons.person_outline_rounded,
                                          size: 62,
                                          color: c.laranja,
                                        )
                                      : Image.memory(
                                          bytesFoto,
                                          gaplessPlayback: true,
                                          width: 116,
                                          height: 116,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person_outline_rounded,
                                              size: 62,
                                              color: c.laranja,
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Material(
                                color: c.laranja,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: _selecionarFoto,
                                  child: const Padding(
                                    padding: EdgeInsets.all(9),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrições do usuário abaixo da foto.
                  Center(
                    child: Text(
                      dados.nome,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: c.texto,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      '@${usuario.isEmpty ? 'usuario' : usuario}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: c.textoSecundario,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      dados.email,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: c.textoSecundario,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Aproveitando o tempo com mais consciência. 🌱',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.45,
                        color: c.texto,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // A edição e o compartilhamento do perfil são mantidos.
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _abrirEdicao(dados),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.laranja,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Editar perfil',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _compartilharPerfil(dados),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c.texto,
                            side: BorderSide(color: c.borda),
                            minimumSize: const Size.fromHeight(42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Compartilhar perfil',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Divider(color: c.borda, height: 1),
                  const SizedBox(height: 18),

                  // Área reservada para postagens futuras.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Publicações',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.texto,
                        ),
                      ),
                      Tooltip(
                        message: 'Criar publicação',
                        child: IconButton(
                          onPressed: _abrirAreaPostagens,
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: c.laranja,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 42,
                            color: c.textoSuave,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Suas publicações aparecerão aqui.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: c.textoSecundario,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
  YkaiCores get c => context.cores;


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
      prefixIcon: Icon(icone, color: c.laranja),
      filled: true,
      fillColor: c.cartao,
      enabledBorder: borda(c.borda),
      focusedBorder: borda(c.laranja, 1.5),
      errorBorder: borda(Colors.red.shade400),
      focusedErrorBorder: borda(Colors.red.shade400, 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.fundo,
      appBar: AppBar(
        backgroundColor: c.fundo,
        foregroundColor: c.texto,
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
                    color: c.verdeClaro,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: c.verde,
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
                            color: c.texto,
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
                  style: GoogleFonts.inter(fontSize: 15, color: c.texto),
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
                  style: GoogleFonts.inter(fontSize: 15, color: c.texto),
                  decoration:
                      _decoracao('E-mail', Icons.alternate_email),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.laranja,
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