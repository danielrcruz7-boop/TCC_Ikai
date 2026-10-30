import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('termos de uso'),
      ),
      body: const Center(
        child: Text(
          'termos de uso',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}