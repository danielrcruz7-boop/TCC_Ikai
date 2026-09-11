import 'package:flutter/material.dart';
//import './cadastro.dart';
//import '../services/dados_mock.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool esconderSenha = true;

  void mostrarMensagem(String mensagem){

  }

  void abrirCadastro(){
    
  }

  void entrar(){

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 241, 243),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 35,),

            Image.asset(
              'assets/Ikai.png',
              height: 100,
              fit: BoxFit.contain,
              ),

              const SizedBox(height: 50,),

              Text(
                'Sing in to your Account',
                textAlign: TextAlign.left,
                style: GoogleFonts.inter( 
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20,),

              Text(
                'Enter your email and password to login',
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30,),

              Center(
                child:  SizedBox(
                  width: 1200, 
                  height: 50,    
                child:  TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text(
                    'E-mail',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  hint: Text (
                    'Exemplo@gmail.com',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                    ),
                  ),         
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ), 
                ),
              ),
            ),
          ),

              const SizedBox(height: 15,),
              
              Center(
                child:  SizedBox(
                  width: 1200, 
                  height: 50,   
                child:  TextField(
                controller: senhaController,
                obscureText: esconderSenha,
                decoration:  InputDecoration(
                  label: Text(
                    'Senha',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  hint: Text(
                    '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock),    
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),             
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        esconderSenha = !esconderSenha;
                      });
                    }, 
                    icon: Icon(
                      esconderSenha 
                      ? Icons.visibility
                      : Icons.visibility_off
                    ),
                  )
                ),
              ),
            ),
          ),

              const SizedBox(height: 25,),

              ElevatedButton.icon(
                onPressed: entrar, 
                icon: const Icon(Icons.login),
                label: Text(
                  "Login",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),

              const SizedBox(height: 10,),

              ElevatedButton.icon(
                onPressed: abrirCadastro,
                icon: const Icon(Icons.person_add),
                label: Text(
                  "Criar usuário",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                ),
              )
            ),

            const SizedBox(height: 10,),

              ElevatedButton.icon(
                onPressed: abrirCadastro,
                icon: const Icon(Icons.person_add),
                label: Text(
                  "Continue with Google",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                ),
              )
            ) 
          ]
        ),
      ),
    );
  }
}


