import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistema de Login',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true
        ),
        home: LoginPage(),
      );
    
  }
}