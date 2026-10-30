import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('alterar informações de acesso'),
      ),
      body: const Center(
        child: Text(
          'alterar informações de acesso',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}