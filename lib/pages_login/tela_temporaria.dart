import 'package:flutter/material.dart';
import './login.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
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
          'assets/Ikai.png',
          height: 350,
          fit: BoxFit.contain,
        ),

    const SizedBox(height: 100),

    const SizedBox(
      
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        strokeWidth: 5,
        color: Colors.white,
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