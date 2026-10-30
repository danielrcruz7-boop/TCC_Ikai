import 'package:flutter/material.dart';

class DadosPessoaisScreen extends StatelessWidget {
  const DadosPessoaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aparencia'),
      ),
      body: const Center(
        child: Text(
          'aparencia',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}