import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controla as preferências de aparência do Ikai (tema, alto contraste e
/// tamanho do texto) e as salva no aparelho.
///
/// É um "singleton": existe uma única instância (`AparenciaController.instancia`)
/// usada pelo main.dart (para montar o MaterialApp) e pela tela de
/// Configurações (para o usuário escolher as opções).
class AparenciaController extends ChangeNotifier {
  AparenciaController._();

  static final AparenciaController instancia = AparenciaController._();

  static const double tamanhoMinimo = 0.8;
  static const double tamanhoMaximo = 1.4;

  /// Limite de segurança: escala do celular × escala do app nunca passa disso,
  /// para o layout não quebrar em casos extremos.
  static const double escalaMaximaTotal = 2.0;

  // Chaves usadas para guardar os valores no aparelho.
  static const String _chaveTema = 'aparencia_tema';
  static const String _chaveContraste = 'aparencia_alto_contraste';
  static const String _chaveTamanho = 'aparencia_tamanho_texto';

  SharedPreferences? _prefs;

  ThemeMode _tema = ThemeMode.light;
  bool _altoContraste = false;
  double _tamanhoTexto = 1.0;

  ThemeMode get tema => _tema;
  bool get altoContraste => _altoContraste;
  double get tamanhoTexto => _tamanhoTexto;

  /// Lê as preferências salvas. Chame no main() ANTES do runApp, assim o app
  /// já abre com o tema correto (sem "piscar" no tema errado).
  Future<void> carregar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _prefs = prefs;

      final nomeTema = prefs.getString(_chaveTema);
      _tema = ThemeMode.values.firstWhere(
        (modo) => modo.name == nomeTema,
        orElse: () => ThemeMode.light,
      );

      _altoContraste = prefs.getBool(_chaveContraste) ?? false;

      final tamanho = prefs.getDouble(_chaveTamanho);
      if (tamanho != null) {
        _tamanhoTexto =
            tamanho.clamp(tamanhoMinimo, tamanhoMaximo).toDouble();
      }
    } catch (_) {
      // Se a leitura falhar, o app simplesmente usa os valores padrão.
    }
  }

  void definirTema(ThemeMode valor) {
    if (_tema == valor) return;
    _tema = valor;
    _prefs?.setString(_chaveTema, valor.name);
    notifyListeners();
  }

  void definirAltoContraste(bool valor) {
    if (_altoContraste == valor) return;
    _altoContraste = valor;
    _prefs?.setBool(_chaveContraste, valor);
    notifyListeners();
  }

  void definirTamanhoTexto(double valor) {
    final novo = valor.clamp(tamanhoMinimo, tamanhoMaximo).toDouble();
    if (_tamanhoTexto == novo) return;
    _tamanhoTexto = novo;
    _prefs?.setDouble(_chaveTamanho, novo);
    notifyListeners();
  }

  /// Usada no `builder` do MaterialApp: multiplica a escala de texto do
  /// celular pela escolha do usuário e aplica em TODAS as páginas.
  static Widget aplicarEscalaDeTexto(BuildContext context, Widget? child) {
    final mq = MediaQuery.of(context);

    final fator = (mq.textScaler.scale(1.0) * instancia.tamanhoTexto)
        .clamp(0.5, escalaMaximaTotal)
        .toDouble();

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(fator)),
      child: child ?? const SizedBox.shrink(),
    );
  }

  /// Escala de texto do CELULAR (sem a escolha do usuário). Só funciona
  /// dentro de páginas do app, pois o MediaQuery delas já vem multiplicado.
  /// Usada na prévia ao vivo da tela de Configurações.
  static double escalaDoSistema(BuildContext context) {
    final aplicada = MediaQuery.textScalerOf(context).scale(1.0);
    return aplicada / instancia.tamanhoTexto;
  }
}