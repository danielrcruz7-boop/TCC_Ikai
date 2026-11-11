import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final c = ControleObjetivos.instance;

  test('primeiro uso: histórico vazio não gera sugestões', () async {
    SharedPreferences.setMockInitialValues({});
    expect(c.historicoCarregado, isFalse);

    await c.carregarHistorico();

    expect(c.historicoCarregado, isTrue);
    expect(c.sugestaoObjetivoId, isNull);
    expect(c.sugestaoCategoriaId, isNull);
    expect(c.sugestaoDuracao, isNull);
  });
}
