import 'package:flutter/material.dart';
import './controle_objetivo.dart';

/// Matérias de "Estudar". Para adicionar uma, inclua uma linha aqui.
const List<Categoria> _materias = [
  Categoria(
    id: 'estudar_matematica',
    titulo: 'Matemática',
    icone: Icons.calculate_outlined,
  ),
  Categoria(
    id: 'estudar_lp',
    titulo: 'LP: Língua Portuguesa',
    icone: Icons.menu_book_outlined,
  ),
  Categoria(
    id: 'estudar_geografia',
    titulo: 'Geografia',
    icone: Icons.public,
  ),
  Categoria(
    id: 'estudar_fisica',
    titulo: 'Física',
    icone: Icons.science_outlined,
  ),
  Categoria(
    id: 'estudar_historia',
    titulo: 'História',
    icone: Icons.account_balance_outlined,
  ),
  Categoria(
    id: 'estudar_arte',
    titulo: 'Arte',
    icone: Icons.palette_outlined,
  ),
];

final Objetivo objetivoEstudo = Objetivo(
  id: 'estudar',
  titulo: 'Estudar',
  icone: Icons.school_outlined,
  categorias: _materias,
  construirTela: (props) =>
      ListaCategorias(categorias: _materias, props: props),
);