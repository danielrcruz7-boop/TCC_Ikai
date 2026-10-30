import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importante: necessário para o SystemNavigator.pop()
import 'home/home.dart';
import '../pages_configurar/controle_objetivo.dart';

class TemporarioPage extends StatefulWidget {
  const TemporarioPage({super.key});

  @override
  State<TemporarioPage> createState() => _TemporarioPageState();
}

class _TemporarioPageState extends State<TemporarioPage> {

  @override
  void initState() {
    super.initState();

    // Exibe a mensagem assim que a tela abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _exibirRecado();
    });
  }

  // Função para exibir a mensagem sobreposta
  void _exibirRecado() {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede de fechar clicando fora
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.indigo),
              SizedBox(width: 8),
              Text('Aviso Importante'),
            ],
          ),
          content: const Text('Você realmente quer acessar agora?'),
          actions: [
            // Botão NÃO: Encerra o aplicativo
            TextButton(
              onPressed: () {
                SystemNavigator.pop(); // Fecha o app
              },
              child: const Text('Não, sair'),
            ),
            
            // Botão SIM: Continua para a próxima tela
            TextButton(
              onPressed: () {
                // 1. Fecha o recado
                Navigator.of(dialogContext).pop();

                // 2. Continua o carregamento e depois vai para a HomePage
                _continuarCarregamento();
              },
              child: const Text('Sim, entrar'),
            ),
          ],
        );
      },
    );
  }

  // Função que faz a contagem final do carregamento e abre a HomePage
  void _continuarCarregamento() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FluxoObjetivosPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5B1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_nome.png',
                height: 225,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}