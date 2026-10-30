import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class notificacaoPage extends StatefulWidget{
  const notificacaoPage({super.key});

  @override
  State<notificacaoPage> createState() => _notificacaoPageState();
}

class _notificacaoPageState extends State<notificacaoPage> {


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 241, 243),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
           

            ]
          ),
        ),
      );
    }
  }