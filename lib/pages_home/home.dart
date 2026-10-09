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

                  // =========================
                  // PRÁTICAS RÁPIDAS
                  // =========================
                  const SizedBox(height: 24),

                  const QuickPracticesSection(),

                  // =========================
                  // SUAS ATIVIDADES (NOVO)
                  // =========================
                  const SizedBox(height: 24),

                  const ActivitiesSection(),
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

// =====================================================
// PRÁTICAS RÁPIDAS
// =====================================================

/// Dados de cada prática do carrossel.
/// [imagePath] é opcional: enquanto for null (ou o arquivo não existir),
/// o cartão mostra um ícone sobre fundo circular colorido.
class QuickPractice {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String? imagePath;
  final VoidCallback? onTap;

  const QuickPractice({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.imagePath,
    this.onTap,
  });
}

class QuickPracticesSection extends StatelessWidget {
  const QuickPracticesSection({super.key});

  // Altura da área do carrossel (cartão de 118 + folga para a sombra)
  static const double _carouselHeight = 124;

  // TODO: quando existirem as páginas de cada prática, preencha o onTap.
  // Para usar fotos, informe imagePath, por exemplo:
  // imagePath: 'assets/praticas/meditacao.png'
  static const List<QuickPractice> _praticas = [
    QuickPractice(
      title: 'Meditação',
      icon: Icons.self_improvement,
      backgroundColor: Color(0xFFEAF5EF),
      iconColor: Color(0xFF4C8D67),
    ),
    QuickPractice(
      title: 'Exercícios',
      icon: Icons.fitness_center,
      backgroundColor: Color(0xFFFBEFEA),
      iconColor: Color(0xFFCB5A34),
    ),
    QuickPractice(
      title: 'Nutrição',
      icon: Icons.restaurant_outlined,
      backgroundColor: Color(0xFFF3F7E6),
      iconColor: Color(0xFF6E8B2F),
    ),
    QuickPractice(
      title: 'Sono',
      icon: Icons.bedtime_outlined,
      backgroundColor: Color(0xFFEDF0F7),
      iconColor: Color(0xFF5A6A99),
    ),
    QuickPractice(
      title: 'Respiração',
      icon: Icons.air,
      backgroundColor: Color(0xFFE8F4F6),
      iconColor: Color(0xFF3F8A99),
    ),
    QuickPractice(
      title: 'Hidratação',
      icon: Icons.water_drop_outlined,
      backgroundColor: Color(0xFFE9F1FB),
      iconColor: Color(0xFF4A7FB5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cabeçalho da seção
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Práticas Rápidas',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF243044),
              ),
            ),
            TextButton(
              // TODO: navegar para o catálogo completo quando existir.
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFD84925),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Ver tudo',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD84925),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Carrossel horizontal
        SizedBox(
          height: _carouselHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Permite que os cartões e sombras apareçam até a borda
            // da tela durante a rolagem, sem corte no padding da Home.
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            itemCount: _praticas.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == _praticas.length - 1 ? 0 : 12,
                  bottom: 4,
                ),
                child: QuickPracticeCard(pratica: _praticas[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class QuickPracticeCard extends StatelessWidget {
  final QuickPractice pratica;

  const QuickPracticeCard({super.key, required this.pratica});

  static const double _width = 96;
  static const double _height = 118;
  static const double _imageSize = 46;
  static const double _radius = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: const Color(0xFFE7EDF1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: pratica.onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularImage(),
                const SizedBox(height: 8),
                Text(
                  pratica.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF243044),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularImage() {
    final fallback = Container(
      width: _imageSize,
      height: _imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pratica.backgroundColor,
      ),
      child: Icon(
        pratica.icon,
        size: 24,
        color: pratica.iconColor,
      ),
    );

    final path = pratica.imagePath;
    if (path == null) return fallback;

    return ClipOval(
      child: Image.asset(
        path,
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
        // Se o arquivo não existir, volta para o ícone sem quebrar o app.
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}

// =====================================================
// SUAS ATIVIDADES (NOVO)
// =====================================================

/// Dados de cada atividade. O progresso é um valor entre 0 e 1;
/// a porcentagem exibida é derivada dele para evitar inconsistências.
class ActivityData {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;

  const ActivityData({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
  });
}

class ActivitiesSection extends StatelessWidget {
  const ActivitiesSection({super.key});

  // Dados demonstrativos estáticos.
  static const List<ActivityData> _atividades = [
    ActivityData(
      title: 'Mente Consciente',
      subtitle: '25 min',
      progress: 0.80,
      color: Color(0xFF4B7F5A), // verde
    ),
    ActivityData(
      title: 'Movimento Diário',
      subtitle: '380 kcal',
      progress: 0.65,
      color: Color(0xFFCC512C), // laranja queimado
    ),
    ActivityData(
      title: 'Qualidade do Sono',
      subtitle: '7.8 horas',
      progress: 0.90,
      color: Color(0xFF4F80ED), // azul
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Suas Atividades',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF243044),
          ),
        ),

        const SizedBox(height: 12),

        for (int i = 0; i < _atividades.length; i++) ...[
          ActivityProgressCard(atividade: _atividades[i]),
          if (i != _atividades.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class ActivityProgressCard extends StatelessWidget {
  final ActivityData atividade;

  const ActivityProgressCard({super.key, required this.atividade});

  static const Color _textoPrincipal = Color(0xFF243044);
  static const Color _textoSecundario = Color(0xFF7B8494);
  static const Color _fundoBarra = Color(0xFFEAF0F1);

  @override
  Widget build(BuildContext context) {
    final porcentagem = (atividade.progress * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EDF1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Linha superior: nome (esquerda) e porcentagem (direita)
          Row(
            children: [
              Expanded(
                child: Text(
                  atividade.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textoPrincipal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$porcentagem%',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _textoPrincipal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Linha inferior: informação complementar + barra de progresso
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  atividade.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _textoSecundario,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: atividade.progress,
                    minHeight: 6,
                    backgroundColor: _fundoBarra,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      atividade.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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