import 'package:flutter/material.dart';


class YkaiCores extends ThemeExtension<YkaiCores> {
  final Color fundo;
  final Color cartao;
  final Color texto;
  final Color textoSecundario;
  final Color textoSuave;
  final Color borda;
  final Color laranja;
  final Color laranjaClaro;
  final Color verde;
  final Color verdeClaro;

  const YkaiCores({
    required this.fundo,
    required this.cartao,
    required this.texto,
    required this.textoSecundario,
    required this.textoSuave,
    required this.borda,
    required this.laranja,
    required this.laranjaClaro,
    required this.verde,
    required this.verdeClaro,
  });

  /// Cores originais do Ikai.
  static const YkaiCores claro = YkaiCores(
    fundo: Color(0xFFFDFBF7),
    cartao: Color(0xFFFFFFFF),
    texto: Color(0xFF243044),
    textoSecundario: Color(0xFF757575),
    textoSuave: Color(0xFF9E9E9E),
    borda: Color(0xFFF0ECE6),
    laranja: Color(0xFFCB5A34),
    laranjaClaro: Color(0xFFFBEFEA),
    verde: Color(0xFF4B7F5A),
    verdeClaro: Color(0xFFEAF2EC),
  );

  static const YkaiCores escuro = YkaiCores(
    fundo: Color(0xFF14171C),
    cartao: Color(0xFF1E232B),
    texto: Color(0xFFEDEFF2),
    textoSecundario: Color(0xFFA3ABB8),
    textoSuave: Color(0xFF7D8696),
    borda: Color(0xFF2D3440),
    laranja: Color(0xFFE0714A),
    laranjaClaro: Color(0xFF3A2620),
    verde: Color(0xFF6FB383),
    verdeClaro: Color(0xFF22332A),
  );

  static const YkaiCores claroContraste = YkaiCores(
    fundo: Color(0xFFFFFFFF),
    cartao: Color(0xFFFFFFFF),
    texto: Color(0xFF000000),
    textoSecundario: Color(0xFF333333),
    textoSuave: Color(0xFF595959),
    borda: Color(0xFF595959),
    laranja: Color(0xFFA8360F),
    laranjaClaro: Color(0xFFFBE3D9),
    verde: Color(0xFF2E6B3F),
    verdeClaro: Color(0xFFDCEFE1),
  );

  static const YkaiCores escuroContraste = YkaiCores(
    fundo: Color(0xFF000000),
    cartao: Color(0xFF0D0D0D),
    texto: Color(0xFFFFFFFF),
    textoSecundario: Color(0xFFE3E7ED),
    textoSuave: Color(0xFFBFC6D1),
    borda: Color(0xFF9AA3B2),
    laranja: Color(0xFFFF8F63),
    laranjaClaro: Color(0xFF3D2216),
    verde: Color(0xFF8FE0A8),
    verdeClaro: Color(0xFF163322),
  );

  @override
  YkaiCores copyWith({
    Color? fundo,
    Color? cartao,
    Color? texto,
    Color? textoSecundario,
    Color? textoSuave,
    Color? borda,
    Color? laranja,
    Color? laranjaClaro,
    Color? verde,
    Color? verdeClaro,
  }) {
    return YkaiCores(
      fundo: fundo ?? this.fundo,
      cartao: cartao ?? this.cartao,
      texto: texto ?? this.texto,
      textoSecundario: textoSecundario ?? this.textoSecundario,
      textoSuave: textoSuave ?? this.textoSuave,
      borda: borda ?? this.borda,
      laranja: laranja ?? this.laranja,
      laranjaClaro: laranjaClaro ?? this.laranjaClaro,
      verde: verde ?? this.verde,
      verdeClaro: verdeClaro ?? this.verdeClaro,
    );
  }

  @override
  YkaiCores lerp(ThemeExtension<YkaiCores>? other, double t) {
    if (other is! YkaiCores) return this;

    Color l(Color a, Color b) => Color.lerp(a, b, t)!;

    return YkaiCores(
      fundo: l(fundo, other.fundo),
      cartao: l(cartao, other.cartao),
      texto: l(texto, other.texto),
      textoSecundario: l(textoSecundario, other.textoSecundario),
      textoSuave: l(textoSuave, other.textoSuave),
      borda: l(borda, other.borda),
      laranja: l(laranja, other.laranja),
      laranjaClaro: l(laranjaClaro, other.laranjaClaro),
      verde: l(verde, other.verde),
      verdeClaro: l(verdeClaro, other.verdeClaro),
    );
  }
}

extension YkaiContexto on BuildContext {
  /// Cores do Ikai para o tema atual. Se o tema ainda não tiver a extensão
  /// registrada (main.dart não ligado), usa a paleta clara.
  YkaiCores get cores =>
      Theme.of(this).extension<YkaiCores>() ?? YkaiCores.claro;
}

/// Preferências de aparência de todo o aplicativo.
class AparenciaController extends ChangeNotifier {
  AparenciaController._();

  static final AparenciaController instancia = AparenciaController._();

  static const double tamanhoMinimo = 0.8;
  static const double tamanhoMaximo = 1.4;

  ThemeMode _tema = ThemeMode.light;
  bool _altoContraste = false;
  double _tamanhoTexto = 1.0;

  ThemeMode get tema => _tema;
  bool get altoContraste => _altoContraste;
  double get tamanhoTexto => _tamanhoTexto;

  void definirTema(ThemeMode valor) {
    if (valor == _tema) return;
    _tema = valor;
    notifyListeners();
  }

  void definirAltoContraste(bool valor) {
    if (valor == _altoContraste) return;
    _altoContraste = valor;
    notifyListeners();
  }

  void definirTamanhoTexto(double valor) {
    final novo = valor.clamp(tamanhoMinimo, tamanhoMaximo).toDouble();
    if (novo == _tamanhoTexto) return;
    _tamanhoTexto = novo;
    notifyListeners();
  }

  /// Escala de texto definida no sistema do aparelho (acessibilidade).
  static double escalaDoSistema(BuildContext context) {
    return MediaQueryData.fromView(View.of(context)).textScaler.scale(1.0);
  }

  /// Use em `MaterialApp(builder: AparenciaController.aplicarEscalaDeTexto)`.
  /// Multiplica a escala do sistema pelo fator escolhido pelo usuário, o que
  /// altera o tamanho de TODOS os textos do aplicativo.
  static Widget aplicarEscalaDeTexto(BuildContext context, Widget? child) {
    final mq = MediaQuery.of(context);
    final fator = mq.textScaler.scale(1.0) * instancia.tamanhoTexto;

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(fator)),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

/// Temas prontos para `MaterialApp(theme: ..., darkTheme: ...)`.
class AparenciaTemas {
  AparenciaTemas._();

  static ThemeData claro({bool altoContraste = false}) {
    return _montar(
      Brightness.light,
      altoContraste ? YkaiCores.claroContraste : YkaiCores.claro,
    );
  }

  static ThemeData escuro({bool altoContraste = false}) {
    return _montar(
      Brightness.dark,
      altoContraste ? YkaiCores.escuroContraste : YkaiCores.escuro,
    );
  }

  /// Mesma semente de cor que o main.dart já usava. Mantida para que as
  /// telas que ainda dependem do tema padrão não mudem de aparência.
  static const Color sementeDeCor = Colors.blue;

  static ThemeData _montar(Brightness brilho, YkaiCores c) {
    return ThemeData(
      colorSchemeSeed: sementeDeCor,
      brightness: brilho,
      useMaterial3: true,
      // Disponibiliza a paleta do Ikai para `context.cores`.
      extensions: <ThemeExtension<dynamic>>[c],
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((estados) {
          if (estados.contains(WidgetState.selected)) return Colors.white;
          return null;
        }),
      ),
    );
  }
}