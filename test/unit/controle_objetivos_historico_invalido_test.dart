import 'package:flutter_test/flutter_test.dart';
import 'package:ikai/pages_configurar/controle_objetivo.dart';
import 'package:ikai/pages_configurar/objetivo_estudo.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Arquivo separado porque o histórico do singleton é carregado só uma vez
// por execução (cada arquivo de teste roda em um isolate próprio).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final c = ControleObjetivos.instance;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'hist_objetivo_id': 'objetivo_removido',
      'hist_categoria_id': 'ler_romance',
      'hist_duracao_s': 99999,
    });
    await c.carregarHistorico();
  });

  tearDown(c.reiniciarSessao);

  test('ignora objetivo que não existe mais no catálogo', () {
    expect(c.sugestaoObjetivoId, isNull);
  });

  test('ignora categoria incompatível com o objetivo escolhido', () {
    c.selecionarObjetivo(objetivoEstudo);
    expect(c.sugestaoCategoriaId, isNull);
  });

  test('ignora duração fora do intervalo permitido', () {
    expect(c.sugestaoDuracao, isNull);
    c.aplicarSugestaoDuracao();
    expect(c.duracaoSegundos, 0);
  });
}
