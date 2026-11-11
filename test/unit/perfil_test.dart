import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_home/home/home.dart';
import 'package:ikai/pages_home/perfil/perfil.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DadosPerfil', () {
    test('guarda nome e e-mail', () {
      const d = DadosPerfil(nome: 'Ana', email: 'ana@email.com');
      expect(d.nome, 'Ana');
      expect(d.email, 'ana@email.com');
    });
  });

  group('PerfilSessao', () {
    tearDown(() {
      PerfilSessao.dados.value = null;
      PerfilSessao.foto.value = null;
    });

    test('começa sem dados e sem foto', () {
      expect(PerfilSessao.dados.value, isNull);
      expect(PerfilSessao.foto.value, isNull);
    });

    test('notifica ouvintes ao atualizar os dados', () {
      DadosPerfil? recebido;
      void ouvinte() => recebido = PerfilSessao.dados.value;
      PerfilSessao.dados.addListener(ouvinte);

      PerfilSessao.dados.value =
          const DadosPerfil(nome: 'Bia', email: 'bia@email.com');

      PerfilSessao.dados.removeListener(ouvinte);
      expect(recebido?.nome, 'Bia');
    });

    test('guarda os bytes da foto', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      PerfilSessao.foto.value = bytes;
      expect(PerfilSessao.foto.value, same(bytes));
    });
  });

  group('PerfilPage', () {
    test('usa valores padrão quando nome e e-mail não são informados', () {
      const p = PerfilPage();
      expect(p.nome, 'Nome do usuário');
      expect(p.email, 'email@exemplo.com');
    });
  });

  group('CircularProgressPainter', () {
    CircularProgressPainter criar(double percent) => CircularProgressPainter(
          percent: percent,
          backgroundColor: Colors.grey,
          progressColor: Colors.green,
        );

    test('espessura padrão é 10', () {
      expect(criar(0.5).strokeWidth, 10);
    });

    test('sempre redesenha', () {
      expect(criar(0.5).shouldRepaint(criar(0.5)), isTrue);
    });

    test('desenha o fundo e o arco sem erros', () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      for (final p in [0.0, 0.84, 1.0]) {
        criar(p).paint(canvas, const Size(120, 120));
      }
      expect(recorder.endRecording(), isNotNull);
    });
  });
}
