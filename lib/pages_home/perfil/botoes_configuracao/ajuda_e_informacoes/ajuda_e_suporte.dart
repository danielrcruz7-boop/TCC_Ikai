import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ajuda e suport'),
      ),
      body: const Center(
        child: Text(
          'ajuda e suport',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}