import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('excluir conta'),
      ),
      body: const Center(
        child: Text(
          'excluir conta',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}