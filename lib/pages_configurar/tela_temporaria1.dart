import 'package:flutter/material.dart';
import './objetivo.dart';

class InicioPage1 extends StatefulWidget {
  const InicioPage1({super.key});

  @override
  State<InicioPage1> createState() => _InicioPage1State();
}

class _InicioPage1State extends State<InicioPage1> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ObjetivosPage(),
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

    const SizedBox(height: 5), 

    Column(
      children: [
        Image.asset(
          'assets/Ikai.png',
          height: 350,
          fit: BoxFit.contain,
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