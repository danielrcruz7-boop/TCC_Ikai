import 'package:flutter/material.dart';
import 'package:ikai/pages_home/home.dart';
import 'resgatar_senha.dart';
import 'cadastro.dart';
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
  bool _checked = false;



  void mostrarMensagem(String mensagem){

  }

  void abrirCadastro(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPage(),
      ),
    );
  }

  void abrirEsqueceuASenha(){
    Navigator.push(context,
     MaterialPageRoute(
      builder: (context) => const ResgatarSenhaPage(),
      ),
    );
  }

  void entrar(){
    Navigator.push(context,
    MaterialPageRoute(
      builder: (context) => const HomePage()
      ),
    );
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
                    'Password',
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _checked,
                        onChanged: (bool? value) {
                          setState(() {
                            _checked = value ?? false;
                          });
                        },
                      ),
                      Text(
                        "Remember me",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,),
                        ),
                      ],
                    ),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: abrirEsqueceuASenha,
                 child: Text( 
                  "Forgot your password?",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                    
                  ),
                )
              ),
            ],
          ),

              const SizedBox(height: 25,),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: entrar,
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCB5A34), // Cor terracota sólida
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: Color(0xFF4B86ED), // Borda azul
                        width: 1.5,
                      ),
                    ),
                  ),
                child: Text(
                  'Log In',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                        fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 10,),

              SizedBox(
                width: double.infinity, // Ou um valor fixo, ex: 300
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        color: Colors.white,
                        thickness: 3,
                      )),
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Or'),
                    ),
                    Expanded(child: Divider(
                      color: Colors.white,
                      thickness: 3,
                    )),
                    ],
                  ),
                ),

              const SizedBox(height: 10,),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      shadowColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 238, 210, 29), // Borda amarela
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo_google.png',
                            height: 25,
                          
                          ),
                        const SizedBox(width: 12),
                        Text(
                        'Continue with Google',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            const SizedBox(height: 10,),


                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      shadowColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 238, 210, 29), // Borda amarela
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo_facebook.png',
                            height: 25,
                          
                          ),
                        const SizedBox(width: 12),
                        Text(
                        'Continue with Facebook',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
          const SizedBox(height: 10,),
          
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account?',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                    fontSize: 14,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: abrirCadastro,
                      child: Text(
                      '  Sign Up',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            ]
          ),
        ),
      );
    }
  }


