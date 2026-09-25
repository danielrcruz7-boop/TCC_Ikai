import 'package:flutter/material.dart';
import './home.dart';

class TemporarioPage extends StatefulWidget {
  const TemporarioPage({super.key});

  @override
  State<TemporarioPage> createState() => _TemporarioPageState();
}

class _TemporarioPageState extends State<TemporarioPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

    });
  }

  @override Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: const Color(0xFFE8D5B1), 
      body: Center( child: SingleChildScrollView( 
        padding: const EdgeInsets.all(24), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [  

    const SizedBox(height: 15), 

    Column(
      children: [
        Image.asset(
          'assets/logo_nome.png',
          height: 150,
          fit: BoxFit.contain,
        ),

    const SizedBox(height: 30),

    const SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        strokeWidth: 5,
      ),
    ),
  ],
)
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}