import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'explorar_model.dart';

/// De onde vêm os conteúdos do Explorar.
///
/// O app não traz vídeo nenhum embutido. Para ligar uma fonte real (por
/// exemplo, a YouTube Data API ou o seu próprio servidor), crie uma classe
/// que implemente esta interface e passe-a ao `ExplorarController`.
abstract class FonteDeConteudo {
  /// Conteúdos da categoria pedida. `forcar` ignora qualquer cache.
  Future<List<ConteudoExplorar>> carregar({
    required String objetivoId,
    required String categoriaId,
    bool forcar = false,
  });
}

/// Catálogo curado, guardado em `assets/explorar/conteudos.json`.
///
/// Você cadastra ali apenas conteúdos reais, de fontes que pode usar
/// legalmente (veja o formato no próprio arquivo). Itens inválidos são
/// ignorados, e um catálogo vazio resulta no estado "ainda não há conteúdos".
class FonteCatalogoLocal implements FonteDeConteudo {
  final String caminhoAsset;

  FonteCatalogoLocal({
    this.caminhoAsset = 'assets/conteudos.json',
  });

  List<ConteudoExplorar>? _cache;

  @override
  Future<List<ConteudoExplorar>> carregar({
    required String objetivoId,
    required String categoriaId,
    bool forcar = false,
  }) async {
    if (forcar) _cache = null;
    final todos = _cache ??= await _lerCatalogo();
    return todos
        .where((c) => c.objetivoId == objetivoId && c.categoriaId == categoriaId)
        .toList(growable: false);
  }

  Future<List<ConteudoExplorar>> _lerCatalogo() async {
    final bruto = await rootBundle.loadString(caminhoAsset);
    final json = jsonDecode(bruto);
    final lista = json is Map ? json['conteudos'] : null;
    if (lista is! List) {
      throw const FormatException(
        'Catálogo inválido: esperado {"conteudos": [ ... ]}.',
      );
    }

    final ids = <String>{};
    final resultado = <ConteudoExplorar>[];
    for (final item in lista) {
      final c = ConteudoExplorar.tentarDeJson(item);
      if (c == null || !ids.add(c.id)) {
        debugPrint('Explorar: item de catálogo ignorado (inválido ou repetido).');
        continue;
      }
      resultado.add(c);
    }
    return resultado;
  }
}

/// Fonte que nunca devolve nada. Útil para testar o estado vazio.
class FonteVazia implements FonteDeConteudo {
  const FonteVazia();

  @override
  Future<List<ConteudoExplorar>> carregar({
    required String objetivoId,
    required String categoriaId,
    bool forcar = false,
  }) async =>
      const [];
}