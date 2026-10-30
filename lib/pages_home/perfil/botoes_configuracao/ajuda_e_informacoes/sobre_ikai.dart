import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sobre ikai'),
      ),
      body: const Center(
        child: Text(
          'sobre ikai',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}