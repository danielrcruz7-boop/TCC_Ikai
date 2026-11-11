import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';

void main() {
  group('duracaoValida', () {
    test('o limite máximo é 3 horas (10.800 s)', () {
      expect(duracaoMaximaSegundos, 10800);
    });

    test('rejeita zero e valores negativos', () {
      expect(duracaoValida(0), isFalse);
      expect(duracaoValida(-1), isFalse);
      expect(duracaoValida(-3600), isFalse);
    });

    test('aceita os limites inferior e superior', () {
      expect(duracaoValida(1), isTrue);
      expect(duracaoValida(duracaoMaximaSegundos), isTrue);
    });

    test('aceita valores intermediários', () {
      expect(duracaoValida(60), isTrue);
      expect(duracaoValida(3600), isTrue);
      expect(duracaoValida(5400), isTrue);
    });

    test('rejeita valores acima de 3 horas', () {
      expect(duracaoValida(duracaoMaximaSegundos + 1), isFalse);
      expect(duracaoValida(24 * 3600), isFalse);
    });
  });

  group('formatarDuracao', () {
    test('zero é exibido como "0s"', () {
      expect(formatarDuracao(0), '0s');
    });

    test('somente segundos', () {
      expect(formatarDuracao(1), '1s');
      expect(formatarDuracao(59), '59s');
    });

    test('somente minutos omite segundos zerados', () {
      expect(formatarDuracao(60), '1min');
      expect(formatarDuracao(240), '4min');
    });

    test('somente horas omite minutos e segundos zerados', () {
      expect(formatarDuracao(3600), '1h');
      expect(formatarDuracao(10800), '3h');
    });

    test('combinações de horas, minutos e segundos', () {
      expect(formatarDuracao(3725), '1h 2min 5s');
      expect(formatarDuracao(3605), '1h 5s');
      expect(formatarDuracao(3660), '1h 1min');
      expect(formatarDuracao(125), '2min 5s');
    });

    test('valores acima do limite continuam formatados', () {
      expect(formatarDuracao(10801), '3h 1s');
    });
  });
}
