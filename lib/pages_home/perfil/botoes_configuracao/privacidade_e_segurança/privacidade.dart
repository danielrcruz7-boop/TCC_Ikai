
import 'package:flutter/material.dart';

class PrivacidadePage extends StatelessWidget {
  const PrivacidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'POLÍTICA DE PRIVACIDADE DO IKAI',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Sua privacidade é importante para nós!\n\n'
              'Esta Política de Privacidade apresenta informações sobre como o Ikai trata os dados dos usuários durante a utilização do aplicativo.\n\n'

              '1. COMPROMISSO COM A PRIVACIDADE\n\n'
              'O Ikai valoriza a privacidade e busca tratar as informações dos usuários com responsabilidade, transparência e segurança, respeitando a legislação aplicável, especialmente a Lei Geral de Proteção de Dados Pessoais (LGPD).\n\n'

              '2. DADOS PESSOAIS\n\n'
              'Dependendo das funcionalidades utilizadas, o aplicativo poderá tratar informações fornecidas pelo próprio usuário, como nome, endereço de e-mail e demais dados necessários para disponibilizar os serviços.\n\n'

              '3. FINALIDADE DO USO DOS DADOS\n\n'
              'As informações eventualmente coletadas poderão ser utilizadas para:\n\n'
              '• Permitir o funcionamento das funcionalidades do aplicativo.\n\n'
              '• Identificar e gerenciar a conta do usuário, quando aplicável.\n\n'
              '• Melhorar a experiência de utilização.\n\n'
              '• Oferecer suporte e responder a solicitações.\n\n'
              '• Garantir a segurança e o funcionamento adequado da plataforma.\n\n'

              '4. COMPARTILHAMENTO DE INFORMAÇÕES\n\n'
              'Os dados pessoais não serão comercializados. O compartilhamento poderá ocorrer quando necessário para o funcionamento dos serviços, mediante base legal adequada, ou para atender a obrigações legais e determinações de autoridades competentes.\n\n'

              '5. SEGURANÇA DOS DADOS\n\n'
              'O Ikai busca adotar medidas técnicas e organizacionais para proteger as informações contra acessos não autorizados, perdas, alterações ou utilizações indevidas.\n\n'

              '6. ARMAZENAMENTO DOS DADOS\n\n'
              'As informações poderão ser armazenadas pelo período necessário para cumprir as finalidades para as quais foram coletadas, respeitando as obrigações legais aplicáveis.\n\n'

              '7. DIREITOS DO USUÁRIO\n\n'
              'De acordo com a LGPD, o usuário poderá solicitar, conforme as condições legais aplicáveis:\n\n'
              '• Confirmação da existência de tratamento de dados.\n\n'
              '• Acesso aos seus dados pessoais.\n\n'
              '• Correção de informações incompletas ou desatualizadas.\n\n'
              '• Anonimização, bloqueio ou eliminação de dados, quando aplicável.\n\n'
              '• Informações sobre o compartilhamento de dados.\n\n'
              '• Revogação do consentimento, quando essa for a base legal utilizada.\n\n'

              '8. ALTERAÇÕES NA POLÍTICA\n\n'
              'Esta Política de Privacidade poderá ser atualizada para refletir mudanças no aplicativo, nas práticas de tratamento de dados ou na legislação. Recomendamos consultar esta página periodicamente.\n\n'

              '9. CONTATO\n\n'
              'Caso tenha dúvidas ou queira exercer seus direitos relacionados aos dados pessoais, entre em contato pelos canais de atendimento disponibilizados pelo Ikai.\n\n'

              'Sua privacidade merece atenção e respeito. Agradecemos por confiar no Ikai!\n\n'

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