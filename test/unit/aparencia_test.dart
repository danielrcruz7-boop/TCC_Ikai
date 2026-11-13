import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_home/perfil/botoes_configuracao/aparencia/aparencia.dart';
import 'package:ikai/tema.dart';

// Testa a aparência usada pelo MaterialApp (main.dart) e pelas telas de
// Perfil/Configurações: lib/pages_home/perfil/botoes_configuracao/aparencia.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final ap = AparenciaController.instancia;

  void restaurarPadrao() {
    ap.definirTema(ThemeMode.light);
    ap.definirAltoContraste(false);
    ap.definirTamanhoTexto(1.0);
  }

  setUp(restaurarPadrao);
  tearDown(restaurarPadrao);

  int contarNotificacoes(VoidCallback acao) {
    var n = 0;
    void ouvinte() => n++;
    ap.addListener(ouvinte);
    acao();
    ap.removeListener(ouvinte);
    return n;
  }

  group('AparenciaController', () {
    test('é um singleton com valores padrão', () {
      expect(identical(AparenciaController.instancia, ap), isTrue);
      expect(ap.tema, ThemeMode.light);
      expect(ap.altoContraste, isFalse);
      expect(ap.tamanhoTexto, 1.0);
    });

    test('definirTema altera o tema e notifica apenas se mudar', () {
      expect(contarNotificacoes(() => ap.definirTema(ThemeMode.dark)), 1);
      expect(ap.tema, ThemeMode.dark);
      expect(contarNotificacoes(() => ap.definirTema(ThemeMode.dark)), 0);
      expect(contarNotificacoes(() => ap.definirTema(ThemeMode.system)), 1);
      expect(ap.tema, ThemeMode.system);
    });

    test('definirAltoContraste notifica apenas se mudar', () {
      expect(contarNotificacoes(() => ap.definirAltoContraste(true)), 1);
      expect(ap.altoContraste, isTrue);
      expect(contarNotificacoes(() => ap.definirAltoContraste(true)), 0);
    });

    test('definirTamanhoTexto aceita valores dentro dos limites', () {
      ap.definirTamanhoTexto(1.2);
      expect(ap.tamanhoTexto, 1.2);
      ap.definirTamanhoTexto(AparenciaController.tamanhoMinimo);
      expect(ap.tamanhoTexto, 0.8);
      ap.definirTamanhoTexto(AparenciaController.tamanhoMaximo);
      expect(ap.tamanhoTexto, 1.4);
    });

    test('definirTamanhoTexto limita valores fora do intervalo [0.8, 1.4]',
        () {
      ap.definirTamanhoTexto(5);
      expect(ap.tamanhoTexto, AparenciaController.tamanhoMaximo);
      ap.definirTamanhoTexto(0);
      expect(ap.tamanhoTexto, AparenciaController.tamanhoMinimo);
    });

    test('definirTamanhoTexto não notifica se o valor limitado não mudar', () {
      ap.definirTamanhoTexto(1.4);
      expect(contarNotificacoes(() => ap.definirTamanhoTexto(9)), 0);
    });
  });

  group('YkaiCores', () {
    test('paleta clara mantém as cores da marca', () {
      expect(YkaiCores.claro.laranja, const Color(0xFFCB5A34));
      expect(YkaiCores.claro.verde, const Color(0xFF4B7F5A));
    });

    test('copyWith substitui somente os campos informados', () {
      final c = YkaiCores.claro.copyWith(laranja: Colors.red);
      expect(c.laranja, Colors.red);
      expect(c.fundo, YkaiCores.claro.fundo);
      expect(c.texto, YkaiCores.claro.texto);
      expect(c.verdeClaro, YkaiCores.claro.verdeClaro);
    });

    test('lerp nos extremos retorna as paletas de origem e destino', () {
      final inicio = YkaiCores.claro.lerp(YkaiCores.escuro, 0);
      final fim = YkaiCores.claro.lerp(YkaiCores.escuro, 1);
      expect(inicio.fundo, YkaiCores.claro.fundo);
      expect(fim.fundo, YkaiCores.escuro.fundo);
      expect(fim.laranja, YkaiCores.escuro.laranja);
    });

    test('lerp no meio interpola as cores', () {
      final meio = YkaiCores.claro.lerp(YkaiCores.escuro, 0.5);
      expect(
        meio.fundo,
        Color.lerp(YkaiCores.claro.fundo, YkaiCores.escuro.fundo, 0.5),
      );
    });

    test('lerp com outro tipo retorna a própria paleta', () {
      expect(YkaiCores.claro.lerp(null, 0.5), same(YkaiCores.claro));
    });
  });

  group('AparenciaTemas', () {
    test('tema claro registra a paleta clara', () {
      final t = AparenciaTemas.claro();
      expect(t.brightness, Brightness.light);
      expect(t.extension<YkaiCores>(), same(YkaiCores.claro));
      expect(t.colorScheme.primary, YkaiCores.claro.laranja);
      expect(t.scaffoldBackgroundColor, YkaiCores.claro.fundo);
    });

    test('tema escuro registra a paleta escura', () {
      final t = AparenciaTemas.escuro();
      expect(t.brightness, Brightness.dark);
      expect(t.extension<YkaiCores>(), same(YkaiCores.escuro));
    });

    test('alto contraste troca a paleta', () {
      expect(
        AparenciaTemas.claro(altoContraste: true).extension<YkaiCores>(),
        same(YkaiCores.claroContraste),
      );
      expect(
        AparenciaTemas.escuro(altoContraste: true).extension<YkaiCores>(),
        same(YkaiCores.escuroContraste),
      );
    });

    test('switch selecionado usa polegar branco', () {
      final cor = AparenciaTemas.claro()
          .switchTheme
          .thumbColor
          ?.resolve({WidgetState.selected});
      expect(cor, Colors.white);
      expect(
        AparenciaTemas.claro().switchTheme.thumbColor?.resolve({}),
        isNull,
      );
    });
  });

  group('integração com widgets', () {
    testWidgets('context.cores lê a paleta do tema atual', (tester) async {
      late YkaiCores lidas;
      await tester.pumpWidget(
        MaterialApp(
          theme: AparenciaTemas.escuro(),
          themeMode: ThemeMode.light,
          home: Builder(
            builder: (context) {
              lidas = context.cores;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(lidas, same(YkaiCores.escuro));
    });

    testWidgets('context.cores usa a paleta clara sem extensão registrada',
        (tester) async {
      late YkaiCores lidas;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              lidas = context.cores;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(lidas, same(YkaiCores.claro));
    });

    testWidgets('aplicarEscalaDeTexto multiplica a escala do sistema',
        (tester) async {
      ap.definirTamanhoTexto(1.2);
      late double escala;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Builder(
            builder: (context) => AparenciaController.aplicarEscalaDeTexto(
              context,
              Builder(
                builder: (context) {
                  escala = MediaQuery.textScalerOf(context).scale(1);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(escala, closeTo(1.8, 1e-9));
    });
  });
}
