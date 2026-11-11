import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'explorar_model.dart';

/// Guarda o progresso dos vídeos (iniciado, concluído, tempo assistido,
/// posição e último acesso). Usa uma única chave do SharedPreferences,
/// separada do histórico e da preferência do `ControleObjetivos`.
class RepositorioProgresso {
  static const String _chave = 'explorar_progresso_v1';
  static const int _maximoDeEntradas = 300;

  final Map<String, ProgressoConteudo> _mapa = {};
  bool _carregado = false;

  // Gravações em fila: a última sempre grava o estado mais recente.
  Future<void> _fila = Future<void>.value();

  Future<void> carregar() async {
    if (_carregado) return;
    try {
      final p = await SharedPreferences.getInstance();
      final bruto = p.getString(_chave);
      if (bruto != null) {
        final json = jsonDecode(bruto);
        if (json is List) {
          for (final item in json) {
            final pr = ProgressoConteudo.tentarDeJson(item);
            if (pr != null) _mapa.putIfAbsent(pr.conteudoId, () => pr);
          }
        }
      }
    } catch (e) {
      debugPrint('Explorar: falha ao ler o progresso: $e');
    }
    _carregado = true;
  }

  ProgressoConteudo? de(String conteudoId) => _mapa[conteudoId];

  /// Registros de uma categoria, do mais recente para o mais antigo.
  List<ProgressoConteudo> daCategoria(String categoriaId) {
    final lista =
        _mapa.values.where((p) => p.categoriaId == categoriaId).toList();
    lista.sort((a, b) => b.ultimoAcesso.compareTo(a.ultimoAcesso));
    return lista;
  }

  /// Atualiza a memória na hora e agenda a gravação em disco.
  void salvar(ProgressoConteudo p) {
    _mapa[p.conteudoId] = p;
    _podar();
    _fila = _fila.then((_) => _gravar());
  }

  void _podar() {
    if (_mapa.length <= _maximoDeEntradas) return;
    final antigos = _mapa.values.toList()
      ..sort((a, b) => a.ultimoAcesso.compareTo(b.ultimoAcesso));
    final excesso = _mapa.length - _maximoDeEntradas;
    for (final p in antigos.take(excesso)) {
      _mapa.remove(p.conteudoId);
    }
  }

  Future<void> _gravar() async {
    try {
      final p = await SharedPreferences.getInstance();
      final json = _mapa.values.map((e) => e.toJson()).toList();
      await p.setString(_chave, jsonEncode(json));
    } catch (e) {
      debugPrint('Explorar: falha ao gravar o progresso: $e');
    }
  }
}