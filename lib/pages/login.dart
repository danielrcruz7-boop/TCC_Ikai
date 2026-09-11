import 'package:flutter/material.dart';
import './cadastro.dart';
import '../services/dados_mock.dart';
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
      backgroundColor: const Color.fromARGB(255, 236, 210, 176),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const SizedBox(height: 35,),

            Image.asset(
              'assets/logo_nome.png',
              height: 130,
              fit: BoxFit.contain,
              ),

              const SizedBox(height: 50,),

              Text(
                'Bem-vindo',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand( 
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 1,),

              Text(
                'Entre com sua conta para acessar o Ikai',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
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
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  hint: Text (
                    'Digite seu email',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                    ),
                  ),         
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90)
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
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  hint: Text(
                    'Digite sua senha',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock),    
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90)
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
                  "Entrar",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),

              const SizedBox(height: 10,),

              OutlinedButton.icon(
                onPressed: abrirCadastro,
                icon: const Icon(Icons.person_add),
                label: Text(
                  "Criar usuário",
                style: GoogleFonts.quicksand(
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


