import 'package:flutter/material.dart';
/*-------------------------------------*/
import 'pages_login/cadastro.dart';
import 'pages_login/login.dart';
import 'pages_login/resgatar_senha.dart';
/*-------------------------------------*/
import './pages_home/tela_temporaria.dart';
import './pages_home/home.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ikai',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true
        ),
        home: LoginPage(),
      );
    
  }
}