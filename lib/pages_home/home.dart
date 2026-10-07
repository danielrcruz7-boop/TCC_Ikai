import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './comunidade.dart';
import './perfil.dart';
import './progresso.dart';
import './explorar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indiceAtual = 0;

  final TextEditingController pesquisaController =
      TextEditingController();

  final List<Widget> telas = const [
    ExplorarPage(),
    ComunidadePage(),
    ProgressoPage(),
    PerfilPage(),
  ];

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),

      body: indiceAtual == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 50,
                left: 14,
                right: 14,
                bottom: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =========================
                  // CABEÇALHO
                  // =========================
                  Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/Temporario_foto_perfil.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: const Color(0xFFE8D5B0),
                            width: 3,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bem-vinda de volta,',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Olá, JAIR BOLSONARO',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Botão sustentabilidade
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFEAF2EC),
                            foregroundColor:
                                const Color(0xFF4B7F5A),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),
                          child: const Icon(
                            Icons.eco_outlined,
                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Botão notificações
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color(0xFF243044),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0xFFE7EDF1),
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // CAMPO DE PESQUISA
                  // =========================
                  TextField(
                    controller: pesquisaController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText:
                          'Como você quer se cuidar hoje?',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(19),
                        borderSide: const BorderSide(
                          color: Color(0xFFE7EDF1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(19),
                        borderSide: const BorderSide(
                          color: Color(0xFF6B7280),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // CARD DE BEM-ESTAR
                  // =========================
                  const WellBeingCard(),
                ],
              ),
            )

          // =========================
          // OUTRAS TELAS
          // =========================
          : IndexedStack(
              index: indiceAtual - 1,
              children: telas,
            ),

      // =========================
      // NAVEGAÇÃO INFERIOR
      // =========================
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: Colors.amber,
        indicatorColor: Colors.deepPurple.shade50,
        selectedIndex: indiceAtual,
        onDestinationSelected: (novoIndice) {
          setState(() {
            indiceAtual = novoIndice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Comunidade',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Progresso',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// CARD DE BEM-ESTAR
// =====================================================

class WellBeingCard extends StatelessWidget {
  const WellBeingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFBEFEA),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // CÍRCULO DE PROGRESSO
          // =========================
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 150,
                child: CustomPaint(
                  painter: CircularProgressPainter(
                    percent: 84 / 100,
                    progressColor:
                        const Color(0xFFCB5A34),
                    backgroundColor:
                        const Color(0xFFE8D5B0),
                  ),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '84%',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFCB5A34),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'GERAL',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF7F8C8D),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(width: 24),

          // =========================
          // TEXTOS
          // =========================
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Etiqueta
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5EF),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Text(
                    'FOCO NO PRESENTE',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4C8D67),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Título
                Text(
                  'Seu bem-estar está florescendo hoje.',
                  style: GoogleFonts.inter(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtítulo
                Text(
                  'Que tal praticar 10 minutos de respiração para cultivar calma?',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7F8C8D),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),      
    );
  }  
}

@override


// =====================================================
// CÍRCULO DE PROGRESSO
// =====================================================

class CircularProgressPainter extends CustomPainter {
  final double percent;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.percent,
    required this.backgroundColor,
    required this.progressColor,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        (size.width - strokeWidth) / 2;

    // Fundo do círculo
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    // Progresso
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    const startAngle = -pi / 2;

    final sweepAngle =
        2 * pi * percent;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    CustomPainter oldDelegate,
  ) {
    return true;
  }
}

