import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_login/cadastro.dart';
import 'package:ikai/pages_login/login.dart';
import 'package:ikai/pages_login/resgatar_senha.dart';

import '../helpers.dart';

void main() {
  configurarFontesParaTeste();

  group('LoginPage', () {
    testWidgets('exibe aviso quando e-mail e senha estão vazios',
        (tester) async {
      await montar(tester, const LoginPage());

      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Preencha todos os campos corretamente'), findsOneWidget);
    });

    testWidgets('exibe aviso quando só o e-mail é informado', (tester) async {
      await montar(tester, const LoginPage());

      await tester.enterText(find.byType(TextField).at(0), 'ana@email.com');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Preencha todos os campos corretamente'), findsOneWidget);
    });

    testWidgets('campos com apenas espaços são considerados vazios',
        (tester) async {
      await montar(tester, const LoginPage());

      await tester.enterText(find.byType(TextField).at(0), '   ');
      await tester.enterText(find.byType(TextField).at(1), '   ');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Preencha todos os campos corretamente'), findsOneWidget);
    });

    testWidgets('alterna a visibilidade da senha', (tester) async {
      await montar(tester, const LoginPage());

      TextField senha() => tester.widget<TextField>(find.byType(TextField).at(1));
      expect(senha().obscureText, isTrue);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(senha().obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('marca e desmarca "Remember me"', (tester) async {
      await montar(tester, const LoginPage());

      Checkbox caixa() => tester.widget<Checkbox>(find.byType(Checkbox));
      expect(caixa().value, isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(caixa().value, isTrue);
    });

    testWidgets('"Forgot your password?" abre a recuperação de senha',
        (tester) async {
      await montar(tester, const LoginPage());

      await tester.tap(find.text('Forgot your password?'));
      await tester.pumpAndSettle();

      expect(find.byType(ResgatarSenhaPage), findsOneWidget);
    });

    testWidgets('"Sign Up" abre o cadastro', (tester) async {
      await montar(tester, const LoginPage());

      await tester.ensureVisible(find.text('  Sign Up'));
      await tester.tap(find.text('  Sign Up'));
      await tester.pumpAndSettle();

      expect(find.byType(CadastroPage), findsOneWidget);
    });
  });

  group('CadastroPage', () {
    Future<void> preencher(
      WidgetTester tester, {
      String nome = 'Ana',
      String email = 'ana@email.com',
      String senha = 'segredo',
      String confirmacao = 'segredo',
    }) async {
      final campos = find.byType(TextField);
      await tester.enterText(campos.at(0), nome);
      await tester.enterText(campos.at(1), email);
      await tester.enterText(campos.at(2), senha);
      await tester.enterText(campos.at(3), confirmacao);
    }

    Future<void> tocarCadastrar(WidgetTester tester) async {
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pump();
    }

    testWidgets('exibe aviso quando há campos vazios', (tester) async {
      await montar(tester, const CadastroPage());

      await preencher(tester, nome: '');
      await tocarCadastrar(tester);

      expect(find.text('Preencha todos os campos corretamente'), findsOneWidget);
    });

    testWidgets('exibe aviso quando as senhas não coincidem', (tester) async {
      await montar(tester, const CadastroPage());

      await preencher(tester, confirmacao: 'outra');
      await tocarCadastrar(tester);

      expect(find.text('As senhas não coincidem'), findsOneWidget);
    });

    testWidgets('não exibe aviso com dados válidos', (tester) async {
      await montar(tester, const CadastroPage());

      await preencher(tester);
      await tocarCadastrar(tester);

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('alterna a visibilidade das duas senhas de forma independente',
        (tester) async {
      await montar(tester, const CadastroPage());

      bool oculto(int i) =>
          tester.widget<TextField>(find.byType(TextField).at(i)).obscureText;

      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pump();

      expect(oculto(2), isFalse);
      expect(oculto(3), isTrue);
    });
  });

  group('ResgatarSenhaPage', () {
    testWidgets('exibe aviso quando o e-mail está vazio', (tester) async {
      await montar(tester, const ResgatarSenhaPage());

      await tester.tap(find.text('To Send'));
      await tester.pump();

      expect(find.text('Preencha o campo corretamente'), findsOneWidget);
    });

    testWidgets('não exibe aviso quando o e-mail é informado', (tester) async {
      await montar(tester, const ResgatarSenhaPage());

      await tester.enterText(find.byType(TextField), 'ana@email.com');
      await tester.tap(find.text('To Send'));
      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
