import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResgatarSenhaPage extends StatefulWidget {
  const ResgatarSenhaPage({super.key});

  @override
  State<ResgatarSenhaPage> createState() => _ResgatarSenhaPageState();
}

class _ResgatarSenhaPageState extends State<ResgatarSenhaPage>{

  final TextEditingController emailController = TextEditingController();

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
      ),
    );
  }

 void verificar() {
  if (
      emailController.text.trim().isEmpty ) {
    mostrarMensagem('Preencha o campo corretamente');
    return;
      } else {
//    entrar();
  }
}
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recover password"),
        backgroundColor: const Color.fromARGB(255, 237, 241, 243),
      ),
      backgroundColor: const Color.fromARGB(255, 237, 241, 243),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

            const SizedBox(height: 15,),

            Image.asset(
              'assets/Ikai.png',
              height: 100,
              fit: BoxFit.contain,
              ),

              const SizedBox(height: 50,),

              Text(
                'Recover Password',
                textAlign: TextAlign.left,
                style: GoogleFonts.inter( 
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20,),

              Text(
                'Enter the recovery email address.',
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

          const SizedBox(height: 45,),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: verificar,
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
                  'To Send',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                        fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      );
    }
  }
