import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sair da conta'),
      ),
      body: const Center(
        child: Text(
          'sair da conta',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}