
import 'package:flutter/material.dart';

class TermosDeUsoPage extends StatelessWidget {
  const TermosDeUsoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TERMOS DE USO DO IKAI',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Bem-vindo ao Ikai!\n\n'
              'Ao utilizar o aplicativo, você concorda com os presentes Termos de Uso. Recomendamos a leitura atenta das informações a seguir para compreender as condições de utilização da plataforma.\n\n'

              '1. SOBRE O IKAI\n\n'
              'O Ikai é um aplicativo desenvolvido com o objetivo de incentivar uma relação mais consciente e equilibrada com a tecnologia, oferecendo conteúdos e atividades que ajudam os usuários a aproveitar melhor seu tempo livre.\n\n'

              '2. ACEITAÇÃO DOS TERMOS\n\n'
              'Ao acessar e utilizar o Ikai, o usuário declara estar ciente das condições estabelecidas nestes termos e concorda em respeitá-las.\n\n'

              '3. UTILIZAÇÃO DO APLICATIVO\n\n'
              'O usuário compromete-se a utilizar o aplicativo de maneira responsável, respeitando sua finalidade e evitando qualquer atividade que possa prejudicar seu funcionamento ou a experiência de outras pessoas.\n\n'

              '4. CONTA E RESPONSABILIDADES\n\n'
              'O usuário é responsável pelas informações fornecidas durante a utilização do aplicativo e deve manter seus dados de acesso protegidos, quando aplicável.\n\n'

              '5. CONTEÚDOS E FUNCIONALIDADES\n\n'
              'Os conteúdos, atividades e funcionalidades disponibilizados pelo Ikai têm como finalidade proporcionar aprendizado, entretenimento e incentivar hábitos digitais mais equilibrados. As funcionalidades podem receber atualizações e melhorias ao longo do tempo.\n\n'

              '6. PROPRIEDADE INTELECTUAL\n\n'
              'Os elementos do aplicativo, incluindo textos, identidade visual, logotipo, organização e demais conteúdos próprios, são protegidos pelas normas aplicáveis de propriedade intelectual. Não é permitido reproduzir ou utilizar esses materiais sem autorização, quando exigida.\n\n'

              '7. LIMITAÇÃO DE RESPONSABILIDADE\n\n'
              'O Ikai busca manter uma experiência adequada aos usuários, mas não garante disponibilidade ininterrupta do serviço. Podem ocorrer interrupções decorrentes de manutenção, atualizações ou problemas técnicos.\n\n'

              '8. ALTERAÇÕES DOS TERMOS\n\n'
              'Estes termos poderão ser atualizados para acompanhar melhorias, mudanças nas funcionalidades ou necessidades do aplicativo. Recomendamos consultar esta página periodicamente.\n\n'

              '9. CONTATO\n\n'
              'Em caso de dúvidas sobre estes Termos de Uso, o usuário poderá utilizar os canais de atendimento disponibilizados pelo Ikai.\n\n'

              'Ao utilizar o Ikai, você concorda em fazer parte de uma experiência digital mais consciente e equilibrada.\n\n'

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