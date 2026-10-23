import 'package:flutter/material.dart';
import '../pages_login/login.dart';

class InicioPage4 extends StatefulWidget {
  const InicioPage4({super.key});

  @override
  State<InicioPage4> createState() => _InicioPage4State();
}

class _InicioPage4State extends State<InicioPage4> {

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