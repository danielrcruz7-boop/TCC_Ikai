import 'package:flutter/material.dart';

// Ajuste este caminho se a pasta do Explorar ficar em outro lugar.
import '../../pages_configurar/controle_objetivo.dart' show TempoRestante;

/// Identidade visual do Explorar. Valores idênticos aos de
/// `controle_objetivo.dart`, onde as constantes são privadas (`_laranja`...).
class EstiloIkai {
  EstiloIkai._();

  static const Color laranja = Color(0xFFCB5A34);
  static const Color laranjaSuave = Color(0xFFFBEFEA);
  static const Color fundo = Color(0xFFF7F8F4);
  static const Color titulo = Color(0xFF253D2D);
  static const Color subtitulo = Color(0xFF68756B);
  static const Color borda = Color(0xFFE0E5DF);
  static const Color superficieSuave = Color(0xFFF0F3EE);

  static const double raioCard = 16;
  static const double margem = 20;
  static const double larguraMaxima = 720;
}

/// Escala de texto atual (o Ikai permite ajustar o tamanho do texto).
/// Usada para dimensionar áreas de altura fixa sem estourar o layout.
double escalaDeTexto(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0).toDouble();

/// Selo pequeno com texto e ícone opcional.
class RotuloChip extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final Color cor;
  final Color fundo;

  const RotuloChip({
    super.key,
    required this.texto,
    this.icone,
    this.cor = EstiloIkai.subtitulo,
    this.fundo = EstiloIkai.superficieSuave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 13, color: cor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela de estado (vazio, erro, sem preferência), no estilo da TelaBloqueio.
class MensagemEstado extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String texto;
  final String? rotuloBotao;
  final VoidCallback? aoTocar;

  const MensagemEstado({
    super.key,
    required this.icone,
    required this.titulo,
    required this.texto,
    this.rotuloBotao,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: EstiloIkai.laranjaSuave,
              ),
              child: Icon(icone, size: 36, color: EstiloIkai.laranja),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: EstiloIkai.titulo,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: EstiloIkai.subtitulo,
              ),
            ),
            if (rotuloBotao != null && aoTocar != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: aoTocar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EstiloIkai.laranja,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    rotuloBotao!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Mostra o tempo restante da sessão. Reaproveita o `TempoRestante` do
/// controlador existente: não cria cronômetro nenhum, só lê o `restante`.
class ChipTempoRestante extends StatelessWidget {
  const ChipTempoRestante({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EstiloIkai.borda),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: EstiloIkai.laranja),
          SizedBox(width: 6),
          TempoRestante(),
        ],
      ),
    );
  }
}

/// Barra superior das telas de conteúdo (voltar + categoria + tempo).
class BarraTopoConteudo extends StatelessWidget {
  final String titulo;

  const BarraTopoConteudo({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Voltar',
            icon: const Icon(Icons.arrow_back, color: EstiloIkai.titulo),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: EstiloIkai.subtitulo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}