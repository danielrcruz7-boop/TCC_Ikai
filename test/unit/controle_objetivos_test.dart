import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:ikai/pages_configurar/objetivo_estudo.dart';
import 'package:ikai/pages_configurar/objetivo_leitura.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Leva o controlador até a etapa de duração com escolhas válidas.
void prepararAteDuracao(ControleObjetivos c, {int h = 0, int m = 0, int s = 0}) {
  c.selecionarObjetivo(objetivoEstudo);
  c.avancar();
  c.selecionarCategoria(objetivoEstudo.buscarCategoria('estudar_fisica')!);
  c.avancar();
  c.definirDuracao(h, m, s);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final c = ControleObjetivos.instance;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'hist_objetivo_id': 'estudar',
      'hist_categoria_id': 'estudar_matematica',
      'hist_duracao_s': 240,
    });
    await c.carregarHistorico();
  });

  setUp(c.reiniciarSessao);
  tearDown(c.reiniciarSessao);

  test('é um singleton', () {
    expect(identical(ControleObjetivos.instance, c), isTrue);
  });

  group('histórico e sugestões', () {
    test('carrega o histórico salvo no aparelho', () {
      expect(c.historicoCarregado, isTrue);
      expect(c.sugestaoObjetivoId, 'estudar');
      expect(c.sugestaoDuracao, 240);
    });

    test('carregarHistorico só lê uma vez e não notifica de novo', () async {
      var notificacoes = 0;
      void ouvinte() => notificacoes++;
      c.addListener(ouvinte);
      await c.carregarHistorico();
      c.removeListener(ouvinte);
      expect(notificacoes, 0);
    });

    test('sugere categoria apenas quando compatível com o objetivo atual', () {
      expect(c.sugestaoCategoriaId, isNull, reason: 'nenhum objetivo');

      c.selecionarObjetivo(objetivoLeitura);
      expect(c.sugestaoCategoriaId, isNull, reason: 'objetivo diferente');

      c.selecionarObjetivo(objetivoEstudo);
      expect(c.sugestaoCategoriaId, 'estudar_matematica');
    });

    test('aplicarSugestaoDuracao converte segundos em h/m/s', () {
      c.aplicarSugestaoDuracao();
      expect([c.horas, c.minutos, c.segundos], [0, 4, 0]);
      expect(c.duracaoSegundos, 240);
    });
  });

  group('estado inicial e reinício', () {
    test('começa na etapa 0, sem escolhas e sem sessão', () {
      expect(c.etapa, 0);
      expect(c.objetivo, isNull);
      expect(c.categoria, isNull);
      expect(c.duracaoSegundos, 0);
      expect(c.estado, EstadoSessao.naoIniciada);
      expect(c.restante.value, Duration.zero);
    });

    test('reiniciarSessao limpa todas as escolhas', () {
      prepararAteDuracao(c, h: 1, m: 2, s: 3);
      c.reiniciarSessao();
      expect(c.etapa, 0);
      expect(c.objetivo, isNull);
      expect(c.categoria, isNull);
      expect([c.horas, c.minutos, c.segundos], [0, 0, 0]);
    });
  });

  group('escolha de objetivo e categoria', () {
    test('não avança na etapa 0 sem objetivo', () {
      expect(c.podeAvancar, isFalse);
      c.avancar();
      expect(c.etapa, 0);
    });

    test('voltar na etapa 0 não faz nada', () {
      c.voltar();
      expect(c.etapa, 0);
    });

    test('selecionar objetivo notifica e libera o avanço', () {
      var notificacoes = 0;
      void ouvinte() => notificacoes++;
      c.addListener(ouvinte);
      c.selecionarObjetivo(objetivoLeitura);
      c.removeListener(ouvinte);

      expect(notificacoes, 1);
      expect(c.objetivo, same(objetivoLeitura));
      expect(c.podeAvancar, isTrue);
    });

    test('rejeita categoria que não pertence ao objetivo', () {
      c.selecionarObjetivo(objetivoEstudo);
      c.avancar();
      c.selecionarCategoria(objetivoLeitura.categorias.first);
      expect(c.categoria, isNull);
      expect(c.podeAvancar, isFalse);
    });

    test('rejeita categoria quando não há objetivo', () {
      c.selecionarCategoria(objetivoEstudo.categorias.first);
      expect(c.categoria, isNull);
    });

    test('trocar de objetivo invalida a categoria escolhida', () {
      c.selecionarObjetivo(objetivoEstudo);
      c.selecionarCategoria(objetivoEstudo.categorias.first);
      expect(c.categoria, isNotNull);

      c.selecionarObjetivo(objetivoLeitura);
      expect(c.categoria, isNull);
    });

    test('reselecionar o mesmo objetivo mantém a categoria', () {
      c.selecionarObjetivo(objetivoEstudo);
      c.selecionarCategoria(objetivoEstudo.categorias.first);
      c.selecionarObjetivo(objetivoEstudo);
      expect(c.categoria, same(objetivoEstudo.categorias.first));
    });

    test('voltar retorna à etapa anterior', () {
      c.selecionarObjetivo(objetivoEstudo);
      c.avancar();
      expect(c.etapa, 1);
      c.voltar();
      expect(c.etapa, 0);
    });
  });

  group('duração', () {
    setUp(() => prepararAteDuracao(c));

    test('chega na etapa 2 e duração zero impede o avanço', () {
      expect(c.etapa, 2);
      expect(c.podeAvancar, isFalse);
    });

    test('duracaoSegundos soma horas, minutos e segundos', () {
      c.definirDuracao(1, 2, 3);
      expect(c.duracaoSegundos, 3723);
    });

    test('3h é aceito e 3h 0min 1s é rejeitado', () {
      c.definirDuracao(3, 0, 0);
      expect(c.podeAvancar, isTrue);
      c.definirDuracao(3, 0, 1);
      expect(c.podeAvancar, isFalse);
    });

    test('avancar não passa da etapa 2', () {
      c.definirDuracao(0, 1, 0);
      c.avancar();
      expect(c.etapa, 2);
    });
  });

  group('confirmar', () {
    test('recusa fora da etapa 2', () async {
      c.selecionarObjetivo(objetivoEstudo);
      expect(await c.confirmar(), isFalse);
      expect(c.estado, EstadoSessao.naoIniciada);
    });

    test('recusa duração inválida', () async {
      prepararAteDuracao(c);
      expect(await c.confirmar(), isFalse);
      expect(c.estado, EstadoSessao.naoIniciada);
    });

    test('inicia a sessão e grava o histórico', () async {
      prepararAteDuracao(c, m: 5);

      expect(await c.confirmar(), isTrue);
      expect(c.estado, EstadoSessao.ativa);
      expect(c.restante.value, const Duration(minutes: 5));

      final p = await SharedPreferences.getInstance();
      expect(p.getString('hist_objetivo_id'), 'estudar');
      expect(p.getString('hist_categoria_id'), 'estudar_fisica');
      expect(p.getInt('hist_duracao_s'), 300);
    });

    test('com sessão ativa, escolhas ficam bloqueadas', () async {
      prepararAteDuracao(c, m: 5);
      await c.confirmar();

      c.selecionarObjetivo(objetivoLeitura);
      c.selecionarCategoria(objetivoEstudo.categorias.first);
      c.definirDuracao(1, 0, 0);

      expect(c.objetivo, same(objetivoEstudo));
      expect(c.categoria?.id, 'estudar_fisica');
      expect(c.duracaoSegundos, 300);
    });

    test('não permite duas sessões ao mesmo tempo', () async {
      prepararAteDuracao(c, m: 5);
      expect(await c.confirmar(), isTrue);
      expect(await c.confirmar(), isFalse);
    });

    test('confirmações simultâneas iniciam apenas uma sessão', () async {
      prepararAteDuracao(c, m: 5);
      final resultados = await Future.wait([c.confirmar(), c.confirmar()]);
      expect(resultados.where((r) => r), hasLength(1));
    });
  });

  group('cronômetro e expiração', () {
    test('verificar não faz nada sem sessão ativa', () {
      c.verificar();
      expect(c.estado, EstadoSessao.naoIniciada);
    });

    test('o tempo restante diminui durante a sessão', () async {
      prepararAteDuracao(c, s: 10);
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      expect(c.estado, EstadoSessao.ativa);
      expect(c.restante.value, lessThan(const Duration(seconds: 10)));
      expect(c.restante.value, greaterThan(Duration.zero));
    });

    test('a sessão expira ao fim da duração', () async {
      prepararAteDuracao(c, s: 1);
      await c.confirmar();

      var notificou = false;
      void ouvinte() {
        if (c.estado == EstadoSessao.expirada) notificou = true;
      }

      c.addListener(ouvinte);
      await Future<void>.delayed(const Duration(milliseconds: 2200));
      c.removeListener(ouvinte);

      expect(c.estado, EstadoSessao.expirada);
      expect(c.restante.value, Duration.zero);
      expect(notificou, isTrue);
    });

    test('expirada é terminal até reiniciar a sessão', () async {
      prepararAteDuracao(c, s: 1);
      await c.confirmar();
      await Future<void>.delayed(const Duration(milliseconds: 2200));

      c.verificar();
      c.selecionarObjetivo(objetivoLeitura);
      expect(await c.confirmar(), isFalse);
      expect(c.estado, EstadoSessao.expirada);

      c.reiniciarSessao();
      expect(c.estado, EstadoSessao.naoIniciada);
      c.selecionarObjetivo(objetivoLeitura);
      expect(c.objetivo, same(objetivoLeitura));
    });
  });
}
