import 'package:flutter/material.dart';
import './controle_objetivo.dart';

/// Categorias de "Ler". Só "Religioso" está confirmado.
/// Para adicionar outra, inclua uma linha `Categoria(...)` aqui.
const List<Categoria> _categoriasLeitura = [
  Categoria(
    id: 'ler_religioso',
    titulo: 'Religioso',
    icone: Icons.auto_stories_outlined,
  ),
];

final Objetivo objetivoLeitura = Objetivo(
  id: 'ler',
  titulo: 'Ler',
  icone: Icons.menu_book_outlined,
  categorias: _categoriasLeitura,
  construirTela: (props) =>
      ListaCategorias(categorias: _categoriasLeitura, props: props),
);