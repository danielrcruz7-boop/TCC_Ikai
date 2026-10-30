import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('central de ajuda'),
      ),
      body: const Center(
        child: Text(
          'central de ajuda',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}