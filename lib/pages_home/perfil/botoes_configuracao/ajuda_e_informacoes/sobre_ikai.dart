
import 'package:flutter/material.dart';

class SobreIkaiPage extends StatelessWidget {
  const SobreIkaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Ikai'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre o Ikai',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            Text(
              'NOSSA HISTÓRIA\n\n'
              'O Ikai nasceu com uma proposta simples: incentivar uma relação mais consciente e equilibrada com a tecnologia. Em um mundo cada vez mais conectado, muitas vezes passamos horas diante das telas sem perceber quanto tempo estamos dedicando a elas.\n\n'
              
              'Pensando nisso, o Ikai foi desenvolvido para oferecer alternativas que ajudem as pessoas a aproveitar melhor seu tempo livre, valorizando experiências, conhecimentos e atividades que vão além do ambiente digital.\n\n'

              'NOSSA MISSÃO\n\n'
              'Incentivar o uso consciente da tecnologia, oferecendo conteúdos e atividades que contribuam para uma rotina mais equilibrada, produtiva e significativa.\n\n'

              'NOSSA VISÃO\n\n'
              'Contribuir para um futuro em que a tecnologia seja utilizada de maneira mais saudável e positiva, sendo uma ferramenta que auxilie as pessoas, sem controlar sua rotina ou consumir todo o seu tempo.\n\n'

              'NOSSOS VALORES\n\n'
              '• Consciência: incentivar escolhas mais responsáveis no ambiente digital.\n\n'
              '• Equilíbrio: valorizar tanto o tempo conectado quanto os momentos longe das telas.\n\n'
              '• Simplicidade: proporcionar uma experiência acessível e fácil de utilizar.\n\n'
              '• Bem-estar: estimular hábitos que contribuam para uma rotina mais saudável.\n\n'
              '• Aprendizado: incentivar a descoberta de novas atividades e conhecimentos.\n\n'

              'NOSSO PROPÓSITO\n\n'
              'Acreditamos que a tecnologia deve trabalhar a nosso favor, e não controlar a maneira como vivemos. Por isso, o Ikai busca transformar o tempo digital em uma oportunidade de descoberta, aprendizado e desenvolvimento pessoal.\n\n'

              'Mais do que um aplicativo, o Ikai é um convite para repensar a forma como utilizamos nosso tempo.\n\n'

              'Ikai — Conecte-se com o que realmente importa.',
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