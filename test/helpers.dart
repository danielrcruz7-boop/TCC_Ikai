import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Os testes não têm acesso à internet: impede o google_fonts de tentar
/// baixar a fonte Inter (o texto é renderizado com a fonte padrão).
void configurarFontesParaTeste() {
  GoogleFonts.config.allowRuntimeFetching = false;
}

/// Monta a tela dentro de um MaterialApp.
///
/// A fonte de teste do Flutter desenha cada caractere como um quadrado (mais
/// largo que a Inter), por isso a área é maior que a de um celular: evita
/// falsos erros de "RenderFlex overflowed" que não ocorrem no aparelho.
Future<void> montar(WidgetTester tester, Widget tela) async {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(home: tela));
}
