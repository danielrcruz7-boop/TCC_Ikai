import 'package:flutter/material.dart';
import 'package:ikai/pages_home/perfil/perfil.dart';

class perfilPage extends StatelessWidget {
  const perfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('perfil'),
      ),
      body: const Center(
        child: Text(
          'perfil',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}