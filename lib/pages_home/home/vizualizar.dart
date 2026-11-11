
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikai/tema.dart';

class PraticasPage extends StatelessWidget {
  const PraticasPage({super.key});

  static const List<PracticeItem> _praticas = [
    PracticeItem(
      title: 'Meditação',
      icon: Icons.self_improvement,
      backgroundColor: Color(0xFFEAF5EF),
      iconColor: Color(0xFF4C8D67),
    ),
    PracticeItem(
      title: 'Exercícios',
      icon: Icons.fitness_center,
      backgroundColor: Color(0xFFFBEFEA),
      iconColor: Color(0xFFCB5A34),
    ),
    PracticeItem(
      title: 'Nutrição',
      icon: Icons.restaurant_outlined,
      backgroundColor: Color(0xFFF3F7E6),
      iconColor: Color(0xFF6E8B2F),
    ),
    PracticeItem(
      title: 'Sono',
      icon: Icons.bedtime_outlined,
      backgroundColor: Color(0xFFEDF0F7),
      iconColor: Color(0xFF5A6A99),
    ),
    PracticeItem(
      title: 'Respiração',
      icon: Icons.air,
      backgroundColor: Color(0xFFE8F4F6),
      iconColor: Color(0xFF3F8A99),
    ),
    PracticeItem(
      title: 'Hidratação',
      icon: Icons.water_drop_outlined,
      backgroundColor: Color(0xFFE9F1FB),
      iconColor: Color(0xFF4A7FB5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.cores;

    return Scaffold(
      backgroundColor: c.fundo,
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: c.texto,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Práticas',
                      style: GoogleFonts.inter(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: c.texto,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                children: [
                  Text(
                    'Cuide de você!',
                    style: GoogleFonts.inter(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: c.texto,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Explore práticas simples para melhorar '
                    'seu bem-estar e desenvolver hábitos mais saudáveis.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: c.textoSecundario,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // TÍTULO DA SEÇÃO
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        color: c.laranja,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Práticas rápidas',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.texto,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Escolha uma atividade para começar.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: c.textoSecundario,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // CARDS DAS PRÁTICAS
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _praticas.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final pratica = _praticas[index];

                      return Material(
                        color: c.cartao,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Você selecionou ${pratica.title}!',
                                  ),
                                ),
                              );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: c.borda),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: pratica.backgroundColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    pratica.icon,
                                    color: pratica.iconColor,
                                    size: 27,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  pratica.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: c.texto,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Explorar prática',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: c.textoSecundario,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // MENSAGEM FINAL
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: c.cartao,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: c.borda),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.spa_outlined,
                          color: c.verde,
                          size: 30,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Pequenas atitudes podem fazer '
                            'uma grande diferença no seu dia!',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              height: 1.5,
                              color: c.texto,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MODELO DOS TÓPICOS
class PracticeItem {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const PracticeItem({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}
