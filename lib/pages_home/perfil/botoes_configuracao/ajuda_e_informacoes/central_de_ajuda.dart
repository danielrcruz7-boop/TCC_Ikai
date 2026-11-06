import 'package:flutter/material.dart';

class CentralDeAjudaPage extends StatelessWidget {
  const CentralDeAjudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Ajuda'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Central de Ajuda do Ikai',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            Text(
              'Bem-vindo à Central de Ajuda!\n\n'
              'O Ikai foi desenvolvido para incentivar uma relação mais consciente com a tecnologia, ajudando você a aproveitar melhor seu tempo livre por meio de conteúdos e atividades que estimulam o aprendizado, a criatividade e o bem-estar.\n\n'

              '1. O QUE É O IKAI?\n\n'
              'O Ikai é um aplicativo que busca promover o uso consciente da tecnologia, oferecendo alternativas para aproveitar o tempo de maneira mais produtiva, equilibrada e significativa.\n\n'

              '2. COMO FUNCIONA O IKAI?\n\n'
              'O aplicativo reúne diferentes funcionalidades e conteúdos que permitem explorar novas possibilidades durante o tempo livre, incentivando hábitos digitais mais saudáveis.\n\n'

              '3. O QUE SÃO AS PRÁTICAS RÁPIDAS?\n\n'
              'As Práticas Rápidas são atividades simples que podem ser realizadas em poucos minutos, proporcionando momentos de aprendizado, criatividade e desenvolvimento pessoal.\n\n'

              '4. PARA QUE SERVEM OS FAVORITOS?\n\n'
              'A área de Favoritos permite salvar conteúdos de seu interesse para encontrá-los facilmente e acessá-los novamente quando desejar.\n\n'

              '5. COMO FUNCIONA MEU PERFIL?\n\n'
              'A área de Perfil reúne informações e opções relacionadas à sua experiência dentro do aplicativo.\n\n'

              '6. COMO APROVEITAR MELHOR O IKAI?\n\n'
              'Explore os conteúdos disponíveis, experimente as Práticas Rápidas e procure estabelecer momentos de uso consciente da tecnologia. Pequenas mudanças podem fazer diferença na sua rotina.\n\n'

              '7. O IKAI POSSUI ALGUM CUSTO?\n\n'
              'Consulte as informações disponibilizadas no próprio aplicativo para conhecer as condições de acesso e eventuais funcionalidades adicionais.\n\n'

              '8. COMO OBTER AJUDA?\n\n'
              'Caso tenha dúvidas ou encontre alguma dificuldade durante a utilização, consulte esta Central de Ajuda ou os canais de atendimento disponibilizados pelo Ikai.\n\n'

              'Ikai — Seu tempo merece ser bem aproveitado!',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}