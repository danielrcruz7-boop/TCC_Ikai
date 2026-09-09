import 'package:flutter/material.dart';
import '../services/dados_mock.dart';

class CadastroPage extends StatefulWidget{
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>{

  final TextEditingController nomeController = TextEditingController();  
  final TextEditingController emailController = TextEditingController();  
  final TextEditingController senhaController = TextEditingController();  
  final TextEditingController confirmaSenhaController = TextEditingController();

  bool esconderSenha = true;
  bool esconderConfirmaSenha = true;

  void mostrarMensagem(mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem))
    );
  }

  void cadastrar(){
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text;
    String confirmaSenha = confirmaSenhaController.text;

    if(nome.isEmpty || email.isEmpty || senha.isEmpty || confirmaSenha.isEmpty){
      mostrarMensagem("Preencha todos os campos.");
      return;
    }

    if(!email.contains('@')){
      mostrarMensagem('Digite um emil válido');
      return;
    }

    if(senha.length < 4){
      mostrarMensagem("Sua senha deve possuir pelo menos 4 caracteris");
      return;
    }

    if(senha != confirmaSenha){
      mostrarMensagem("As senhas devem ser iguais");
      return;
    }

    bool emailExiste = false;

    for(var usuario in usuarios){
      if(usuario['email'] == email){
        emailExiste = true;
        break;
      }
    }

    if(emailExiste){
      mostrarMensagem("Email já existente");
      return;
    }

    usuarios.add(
      {
        'nome': nome,
        'email': email,
        'senha' : senha
      }
    );
    mostrarMensagem("Usuario cadastrado com sucesso");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar Usuário'
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20,),

            const Icon(Icons.person_add, size: 90,),

            const SizedBox(height: 15,),

            const Text(
              'Criar conta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 15,),

            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Digite seu nome',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 15,),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 15,),

            TextField(
              controller: senhaController,
              obscureText: esconderSenha,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      esconderSenha = !esconderSenha;
                    });
                  },
                  icon: Icon(
                    esconderSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15,),

            TextField(
              controller: confirmaSenhaController,
              obscureText: esconderConfirmaSenha,
              decoration: InputDecoration(
                labelText: 'Confirma Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      esconderConfirmaSenha = !esconderConfirmaSenha;
                    });
                  },
                  icon: Icon(
                    esconderConfirmaSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25,),

            ElevatedButton.icon(
              onPressed: cadastrar, 
              icon: const Icon(Icons.person_add),
              label: const Text('Cadastrar'),
              ),

              const SizedBox(height: 10,),

              OutlinedButton(
                onPressed: () { 
                 Navigator.pop(context);
                },
                child: Text(
                  "Voltar para o login"
                )
                )
          ],
        ),
      )
    );
  }

}