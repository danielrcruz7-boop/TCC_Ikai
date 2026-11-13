import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_home/perfil/botoes_configuracao/aparencia/aparencia.dart';
import 'package:ikai/tema.dart';

// Testa lib/tema.dart, usado pela tela de notificações (context.cores).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final ap = AparenciaController.instancia;

  tearDown(() {
    ap.definirTema(ThemeMode.light);
    ap.definirAltoContraste(false);
    ap.definirTamanhoTexto(1.0);
  });

  group('AparenciaController (tema.dart)', () {
    test('valores padrão', () {
      expect(ap.tema, ThemeMode.light);
      expect(ap.altoContraste, isFalse);
      expect(ap.tamanhoTexto, 1.0);
    });

    test('altera tema e alto contraste', () {
      ap.definirTema(ThemeMode.dark);
      ap.definirAltoContraste(true);
      expect(ap.tema, ThemeMode.dark);
      expect(ap.altoContraste, isTrue);
    });

    test('tamanho do texto é limitado ao intervalo [0.8, 1.4]', () {
      ap.definirTamanhoTexto(0.1);
      expect(ap.tamanhoTexto, 0.8);
      ap.definirTamanhoTexto(3);
      expect(ap.tamanhoTexto, 1.4);
      ap.definirTamanhoTexto(1.1);
      expect(ap.tamanhoTexto, 1.1);
    });

    test('só notifica quando o valor muda', () {
      var n = 0;
      void ouvinte() => n++;
      ap.addListener(ouvinte);
      ap.definirTema(ThemeMode.light);
      ap.definirAltoContraste(false);
      ap.definirTamanhoTexto(1.0);
      expect(n, 0);
      ap.definirTema(ThemeMode.system);
      expect(n, 1);
      ap.removeListener(ouvinte);
    });
  });

  group('YkaiCores (tema.dart)', () {
    test('copyWith e lerp', () {
      final c = YkaiCores.escuro.copyWith(verde: Colors.green);
      expect(c.verde, Colors.green);
      expect(c.fundo, YkaiCores.escuro.fundo);

      expect(
        YkaiCores.claro.lerp(YkaiCores.claroContraste, 1).texto,
        YkaiCores.claroContraste.texto,
      );
      expect(YkaiCores.claro.lerp(null, 1), same(YkaiCores.claro));
    });
  });

  group('AparenciaTemas (tema.dart)', () {
    test('registra a paleta correta em cada combinação', () {
      expect(AparenciaTemas.claro().extension<YkaiCores>(),
          same(YkaiCores.claro));
      expect(AparenciaTemas.escuro().extension<YkaiCores>(),
          same(YkaiCores.escuro));
      expect(AparenciaTemas.claro(altoContraste: true).extension<YkaiCores>(),
          same(YkaiCores.claroContraste));
      expect(AparenciaTemas.escuro(altoContraste: true).extension<YkaiCores>(),
          same(YkaiCores.escuroContraste));
    });

    test('brilho de cada tema', () {
      expect(AparenciaTemas.claro().brightness, Brightness.light);
      expect(AparenciaTemas.escuro().brightness, Brightness.dark);
    });
  });
}
