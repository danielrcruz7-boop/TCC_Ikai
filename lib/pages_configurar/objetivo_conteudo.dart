import 'package:flutter/material.dart';
import './controle_objetivo.dart';

/// Categorias de "Ver conteúdo". Só "Científico" está confirmado.
/// Para adicionar outra, inclua uma linha `Categoria(...)` aqui.
const List<Categoria> _categoriasConteudo = [
  Categoria(
    id: 'ver_cientifico',
    titulo: 'Científico',
    icone: Icons.science_outlined,
  ),
];

final Objetivo objetivoConteudo = Objetivo(
  id: 'ver_conteudo',
  titulo: 'Ver conteúdo',
  icone: Icons.play_circle_outline,
  categorias: _categoriasConteudo,
  construirTela: (props) =>
      ListaCategorias(categorias: _categoriasConteudo, props: props),
);