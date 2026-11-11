import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:ikai/pages_configurar/objetivo_conteudo.dart';
import 'package:ikai/pages_configurar/objetivo_estudo.dart';
import 'package:ikai/pages_configurar/objetivo_leitura.dart';

void main() {
  group('todosOsObjetivos', () {
    test('contém os três objetivos na ordem exibida', () {
      expect(
        todosOsObjetivos.map((o) => o.id).toList(),
        ['ver_conteudo', 'ler', 'estudar'],
      );
    });

    test('quantidade de categorias por objetivo', () {
      expect(objetivoConteudo.categorias, hasLength(6));
      expect(objetivoLeitura.categorias, hasLength(12));
      expect(objetivoEstudo.categorias, hasLength(12));
    });

    test('identificadores de objetivos são únicos', () {
      final ids = todosOsObjetivos.map((o) => o.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('identificadores de categorias são únicos em todo o catálogo', () {
      final ids = [
        for (final o in todosOsObjetivos) ...o.categorias.map((c) => c.id),
      ];
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('todo objetivo e categoria possui título não vazio', () {
      for (final o in todosOsObjetivos) {
        expect(o.titulo.trim(), isNotEmpty);
        for (final c in o.categorias) {
          expect(c.titulo.trim(), isNotEmpty, reason: c.id);
        }
      }
    });

    test('categorias usam o prefixo do respectivo objetivo', () {
      const prefixos = {
        'ver_conteudo': 'ver_',
        'ler': 'ler_',
        'estudar': 'estudar_',
      };
      for (final o in todosOsObjetivos) {
        for (final c in o.categorias) {
          expect(c.id, startsWith(prefixos[o.id]!), reason: c.id);
        }
      }
    });
  });

  group('buscarObjetivo', () {
    test('retorna o objetivo correspondente ao id', () {
      expect(buscarObjetivo('ler')?.titulo, 'Ler');
      expect(buscarObjetivo('estudar')?.titulo, 'Estudar');
      expect(buscarObjetivo('ver_conteudo')?.titulo, 'Ver conteúdo');
    });

    test('retorna null para id nulo ou inexistente', () {
      expect(buscarObjetivo(null), isNull);
      expect(buscarObjetivo(''), isNull);
      expect(buscarObjetivo('correr'), isNull);
    });

    test('a busca diferencia maiúsculas de minúsculas', () {
      expect(buscarObjetivo('LER'), isNull);
    });
  });

  group('Objetivo.buscarCategoria', () {
    test('encontra categoria que pertence ao objetivo', () {
      expect(
        objetivoEstudo.buscarCategoria('estudar_matematica')?.titulo,
        'Matemática',
      );
      expect(
        objetivoLeitura.buscarCategoria('ler_religioso')?.titulo,
        'Religioso',
      );
    });

    test('não encontra categoria de outro objetivo', () {
      expect(objetivoEstudo.buscarCategoria('ler_romance'), isNull);
      expect(objetivoConteudo.buscarCategoria('estudar_fisica'), isNull);
    });

    test('retorna null para id nulo ou inexistente', () {
      expect(objetivoLeitura.buscarCategoria(null), isNull);
      expect(objetivoLeitura.buscarCategoria('nao_existe'), isNull);
    });

    test('funciona com objetivos criados manualmente', () {
      const cat = Categoria(id: 'x_a', titulo: 'A', icone: Icons.star);
      final objetivo = Objetivo(
        id: 'x',
        titulo: 'X',
        icone: Icons.star,
        categorias: const [cat],
        construirTela: (_) => const SizedBox(),
      );
      expect(objetivo.buscarCategoria('x_a'), same(cat));
      expect(objetivo.buscarCategoria('x_b'), isNull);
    });
  });

  group('construirTela', () {
    test('cada objetivo constrói uma ListaCategorias com as suas categorias',
        () {
      for (final o in todosOsObjetivos) {
        final tela = o.construirTela(
          PropsCategorias(
            selecionadaId: null,
            sugeridaId: null,
            aoSelecionar: (_) {},
          ),
        );
        expect(tela, isA<ListaCategorias>());
        expect((tela as ListaCategorias).categorias, o.categorias);
      }
    });
  });
}
