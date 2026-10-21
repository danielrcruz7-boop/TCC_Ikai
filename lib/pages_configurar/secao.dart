
import 'package:flutter/material.dart';
import './limite.dart';

class SecaoPage extends StatefulWidget {
  const SecaoPage({super.key});

  @override
  State<SecaoPage> createState() => _SecaoPageState();
}

class _SecaoPageState extends State<SecaoPage> {
  final List<String> Secao = [
    'Melhorar o sono',
    'Estresse e ansiedade',
    'Saúde emocional',
    'Autoconhecimento',
    'Criar hábitos saudáveis',
    'Mais felicidade',
  ];

  final List<IconData> icones = [
    Icons.nightlight_round,
    Icons.psychology_alt_outlined,
    Icons.favorite_border,
    Icons.spa_outlined,
    Icons.track_changes,
    Icons.sentiment_satisfied_alt,
  ];

  // Guarda apenas um objetivo selecionado.
  String? objetivoSelecionado;

  // Seleciona um único objetivo por vez.
  void selecionarObjetivo(String objetivo) {
    setState(() {
      objetivoSelecionado = objetivo;
    });
  }

    void abrirlimite(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const limitePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFFCB5A34);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Etapa 1 de 3',
                style: TextStyle(
                  backgroundColor:Color(0xFFEDF1F3),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Qual é o seu objetivo?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF253D2D),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Escolha o que você gostaria de melhorar '
                'na sua rotina.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF68756B),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: Secao.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),

                  itemBuilder: (context, index) {
                    final objetivo = Secao[index];

                    // Verifica se este card está selecionado.
                    final selecionado =
                        objetivoSelecionado == objetivo;

                    return InkWell(
                      onTap: () =>
                          selecionarObjetivo(objetivo),

                      borderRadius: BorderRadius.circular(16),

                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: selecionado
                              ? const Color(0xFFE4EFE5)
                              : Colors.white,

                          borderRadius:
                              BorderRadius.circular(16),

                          border: Border.all(
                            color: selecionado
                                ? verde
                                : const Color(0xFFE0E5DF),

                            width: selecionado ? 2 : 1,
                          ),
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,

                              decoration: BoxDecoration(
                                color: selecionado
                                    ? const Color(0xFFD0E3D2)
                                    : const Color(0xFFF0F3EE),

                                borderRadius:
                                    BorderRadius.circular(12),
                              ),

                              child: Icon(
                                icones[index],
                                color: verde,
                                size: 26,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                objetivo,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF263D2D),
                                ),
                              ),
                            ),

                            Icon(
                              selecionado
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,

                              color: selecionado
                                  ? verde
                                  : Colors.grey.shade400,

                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  onPressed: abrirlimite,

                          // Navegue para a próxima tela aqui.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verde,

                    disabledBackgroundColor:
                        const Color(0xFFCAD5CA),

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
