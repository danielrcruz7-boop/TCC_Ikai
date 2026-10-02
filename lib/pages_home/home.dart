
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
                  // Cabeçalho
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

                      // Botão de sustentabilidade
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

                      // Botão de notificações
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

                  // Campo de pesquisa
                  TextField(
                    controller: pesquisaController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 0, 0, 0),
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
                          color: Color(0xFF4B7F5A),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            )
          : IndexedStack(
              index: indiceAtual - 1,
              children: [
                ComunidadePage(),
                ProgressoPage(),
                PerfilPage(),
              ],
            ),

      // Barra de navegação inferior
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