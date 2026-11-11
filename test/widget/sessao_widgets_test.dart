import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:ikai/pages_configurar/objetivo_estudo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';

void main() {
  final c = ControleObjetivos.instance;

  setUpAll(() => SharedPreferences.setMockInitialValues({}));
  setUp(c.reiniciarSessao);
  tearDown(c.reiniciarSessao);

  group('OpcaoCard', () {
    testWidgets('mostra o selo "Sugestão" só quando sugerido e não selecionado',
        (tester) async {
      Future<void> montarCard({required bool sel, required bool sug}) =>
          montar(
            tester,
            Scaffold(
              body: OpcaoCard(
                titulo: 'Ler',
                icone: Icons.book,
                selecionado: sel,
                sugerido: sug,
                onTap: () {},
              ),
            ),
          );

      await montarCard(sel: false, sug: true);
      expect(find.text('Sugestão'), findsOneWidget);
      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);

      await montarCard(sel: true, sug: true);
      expect(find.text('Sugestão'), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('chama onTap ao tocar', (tester) async {
      var toques = 0;
      await montar(
        tester,
        Scaffold(
          body: OpcaoCard(
            titulo: 'Estudar',
            icone: Icons.school,
            selecionado: false,
            sugerido: false,
            onTap: () => toques++,
          ),
        ),
      );
      await tester.tap(find.text('Estudar'));
      expect(toques, 1);
    });
  });

  group('ListaCategorias', () {
    testWidgets('lista as categorias e repassa a escolha', (tester) async {
      Categoria? escolhida;
      await montar(
        tester,
        Scaffold(
          body: ListaCategorias(
            categorias: objetivoEstudo.categorias.take(3).toList(),
            props: PropsCategorias(
              selecionadaId: 'estudar_lp',
              sugeridaId: 'estudar_ingles',
              aoSelecionar: (cat) => escolhida = cat,
            ),
          ),
        ),
      );

      expect(find.byType(OpcaoCard), findsNWidgets(3));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Sugestão'), findsOneWidget);

      await tester.tap(find.text('Matemática'));
      expect(escolhida?.id, 'estudar_matematica');
    });
  });

  group('FluxoObjetivosPage', () {
    testWidgets('percorre as 3 etapas até a duração', (tester) async {
      await montar(tester, const FluxoObjetivosPage());
      await tester.pumpAndSettle();

      expect(find.text('Etapa 1 de 3'), findsOneWidget);
      ElevatedButton botao() =>
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(botao().onPressed, isNull, reason: 'sem objetivo selecionado');

      await tester.tap(find.text('Estudar'));
      await tester.pump();
      await tester.tap(find.text('Continuar'));
      await tester.pump();

      expect(find.text('Etapa 2 de 3'), findsOneWidget);
      expect(find.text('Qual categoria você quer?'), findsOneWidget);

      await tester.tap(find.text('Física'));
      await tester.pump();
      await tester.tap(find.text('Continuar'));
      await tester.pump();

      expect(find.text('Etapa 3 de 3'), findsOneWidget);
      expect(find.text('Escolha uma duração maior que zero.'), findsOneWidget);
      expect(find.text('Confirmar e entrar'), findsOneWidget);
      expect(botao().onPressed, isNull, reason: 'duração zero');
    });

    testWidgets('botão voltar retorna à etapa anterior', (tester) async {
      await montar(tester, const FluxoObjetivosPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ler'));
      await tester.pump();
      await tester.tap(find.text('Continuar'));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      expect(find.text('Etapa 1 de 3'), findsOneWidget);
    });
  });

  group('SessaoGuard e TelaBloqueio', () {
    testWidgets('exibe o conteúdo enquanto a sessão não expira',
        (tester) async {
      await montar(tester, const SessaoGuard(child: Text('Conteúdo')));
      expect(find.text('Conteúdo'), findsOneWidget);
      expect(find.byType(TelaBloqueio), findsNothing);
    });

    testWidgets('substitui o conteúdo pela tela de bloqueio ao expirar',
        (tester) async {
      await tester.runAsync(() async {
        c.selecionarObjetivo(objetivoEstudo);
        c.avancar();
        c.selecionarCategoria(objetivoEstudo.categorias.first);
        c.avancar();
        c.definirDuracao(0, 0, 1);
        await c.confirmar();
      });
      expect(c.estado, EstadoSessao.ativa);

      await montar(tester, const SessaoGuard(child: Text('Conteúdo')));
      expect(find.text('Conteúdo'), findsOneWidget);

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 1200)),
      );
      c.verificar();
      await tester.pump();

      expect(c.estado, EstadoSessao.expirada);
      expect(find.text('Conteúdo'), findsNothing);
      expect(find.text('Seu tempo acabou!'), findsOneWidget);
    });

    testWidgets('"Iniciar nova sessão" reinicia o controlador',
        (tester) async {
      await montar(tester, const TelaBloqueio());
      c.selecionarObjetivo(objetivoEstudo);

      await tester.tap(find.text('Iniciar nova sessão'));
      await tester.pump();

      expect(c.estado, EstadoSessao.naoIniciada);
      expect(c.objetivo, isNull);
    });
  });

  group('TempoRestante', () {
    testWidgets('formata o tempo restante como HH:MM:SS', (tester) async {
      await montar(tester, const Scaffold(body: TempoRestante()));
      expect(find.text('00:00:00'), findsOneWidget);

      c.restante.value = const Duration(hours: 1, minutes: 2, seconds: 5);
      await tester.pump();
      expect(find.text('01:02:05'), findsOneWidget);
    });
  });
}
