import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './controle_objetivo.dart';

class InicioPage1 extends StatefulWidget {
  const InicioPage1({super.key});

  @override
  State<InicioPage1> createState() => _InicioPage1State();
}

class _InicioPage1State extends State<InicioPage1> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      mostrarRecado();
    });
  }

  Future<void> mostrarRecado() async {
    final resposta = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF7F8F4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Bem-vindo ao Ikai!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF253D2D),
            ),
          ),
          content: const Text(
            'Deseja continuar e começar a utilizar o aplicativo?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF68756B),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF253D2D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('sim, continuar'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFCB5A34),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Não, sair'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (resposta == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FluxoObjetivosPage(),
        ),
      );
    } else if (resposta == false) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5B1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 5),
              Column(
                children: [
                  Image.asset(
                    'assets/Ikai.png',
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}