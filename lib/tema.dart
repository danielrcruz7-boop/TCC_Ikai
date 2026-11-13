import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static const claro = YkaiCores(
    fundo: Color(0xFFFDFBF7),
    cartao: Colors.white,
    texto: Color(0xFF243044),
    textoSecundario: Color(0xFF757575),
    textoSuave: Color(0xFF9E9E9E),
    borda: Color(0xFFF0ECE6),
    laranja: Color(0xFFCB5A34),
    laranjaClaro: Color(0xFFFBEFEA),
    verde: Color(0xFF4B7F5A),
    verdeClaro: Color(0xFFEAF2EC),
  );

  static const escuro = YkaiCores(
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

  static const claroContraste = YkaiCores(
    fundo: Colors.white,
    cartao: Colors.white,
    texto: Colors.black,
    textoSecundario: Color(0xFF333333),
    textoSuave: Color(0xFF595959),
    borda: Color(0xFF595959),
    laranja: Color(0xFFA8360F),
    laranjaClaro: Color(0xFFFBE3D9),
    verde: Color(0xFF2E6B3F),
    verdeClaro: Color(0xFFDCEFE1),
  );

  static const escuroContraste = YkaiCores(
    fundo: Colors.black,
    cartao: Color(0xFF0D0D0D),
    texto: Colors.white,
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
  YkaiCores get cores =>
      Theme.of(this).extension<YkaiCores>() ?? YkaiCores.claro;

  /// true quando o tema que está valendo agora é o escuro.
  bool get modoEscuro => Theme.of(this).brightness == Brightness.dark;

  Color corDestaque(Color base) =>
      modoEscuro ? Color.lerp(base, Colors.white, 0.35)! : base;

  Color fundoDestaque(Color fundoClaro, Color base) =>
      modoEscuro ? base.withValues(alpha: 0.22) : fundoClaro;
}

/// Monta os temas do Ikai (claro/escuro, com ou sem alto contraste).
class AparenciaTemas {
  AparenciaTemas._();

  static ThemeData claro({bool altoContraste = false}) {
    return _montar(
      Brightness.light,
      altoContraste ? YkaiCores.claroContraste : YkaiCores.claro,
      altoContraste,
    );
  }

  static ThemeData escuro({bool altoContraste = false}) {
    return _montar(
      Brightness.dark,
      altoContraste ? YkaiCores.escuroContraste : YkaiCores.escuro,
      altoContraste,
    );
  }

  /// Escolhe texto branco ou preto, o que contrastar mais com [fundo].
  static Color _sobre(Color fundo) =>
      ThemeData.estimateBrightnessForColor(fundo) == Brightness.dark
          ? Colors.white
          : Colors.black;

  static ThemeData _montar(
    Brightness brilho,
    YkaiCores c,
    bool altoContraste,
  ) {
    final larguraBorda = altoContraste ? 1.5 : 1.0;
    final sobreLaranja = _sobre(c.laranja);
    final sobreVerde = _sobre(c.verde);

    final esquema = ColorScheme.fromSeed(
      seedColor: c.laranja,
      brightness: brilho,
    ).copyWith(
      primary: c.laranja,
      onPrimary: sobreLaranja,
      primaryContainer: c.laranjaClaro,
      onPrimaryContainer: c.texto,
      secondary: c.verde,
      onSecondary: sobreVerde,
      secondaryContainer: c.verdeClaro,
      onSecondaryContainer: c.texto,
      surface: c.fundo,
      onSurface: c.texto,
      onSurfaceVariant: c.textoSecundario,
      outline: c.borda,
      outlineVariant: c.borda,
      surfaceContainerLowest: c.fundo,
      surfaceContainerLow: c.cartao,
      surfaceContainer: c.cartao,
      surfaceContainerHigh: c.cartao,
      surfaceContainerHighest: c.cartao,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brilho,
      colorScheme: esquema,
    );

    return base.copyWith(
      scaffoldBackgroundColor: c.fundo,
      extensions: <ThemeExtension<dynamic>>[c],

      // Todos os textos que não definem cor própria usam a cor do tema.
      textTheme: base.textTheme.apply(
        bodyColor: c.texto,
        displayColor: c.texto,
      ),
      iconTheme: IconThemeData(color: c.texto),

      appBarTheme: AppBarTheme(
        backgroundColor: c.fundo,
        foregroundColor: c.texto,
        iconTheme: IconThemeData(color: c.texto),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        // Ícones da barra de status (hora, bateria) legíveis nos dois temas.
        systemOverlayStyle: brilho == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: c.cartao,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: c.borda, width: larguraBorda),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: c.cartao,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.borda, width: larguraBorda),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.cartao,
        modalBackgroundColor: c.cartao,
        surfaceTintColor: Colors.transparent,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: c.cartao,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.borda, width: larguraBorda),
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(c.cartao),
          surfaceTintColor:
              const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: c.borda,
        thickness: larguraBorda,
      ),

      listTileTheme: ListTileThemeData(
        textColor: c.texto,
        iconColor: c.textoSecundario,
      ),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: c.textoSuave),
        labelStyle: TextStyle(color: c.textoSecundario),
        prefixIconColor: c.textoSecundario,
        suffixIconColor: c.textoSecundario,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.borda, width: larguraBorda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.laranja, width: 2),
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.laranja,
        selectionHandleColor: c.laranja,
        selectionColor: c.laranja.withValues(alpha: 0.3),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.cartao,
        selectedItemColor: c.laranja,
        unselectedItemColor: c.textoSuave,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.cartao,
        surfaceTintColor: Colors.transparent,
        indicatorColor: c.laranjaClaro,
        iconTheme: WidgetStateProperty.resolveWith((estados) {
          final ativo = estados.contains(WidgetState.selected);
          return IconThemeData(
            color: ativo ? c.laranja : c.textoSecundario,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((estados) {
          final ativo = estados.contains(WidgetState.selected);
          return TextStyle(
            color: ativo ? c.laranja : c.textoSecundario,
          );
        }),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: c.cartao,
        selectedColor: c.laranjaClaro,
        side: BorderSide(color: c.borda, width: larguraBorda),
        labelStyle: TextStyle(color: c.texto),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.texto,
        contentTextStyle: TextStyle(color: c.fundo),
        actionTextColor: c.laranja,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.laranja,
        linearTrackColor: c.laranjaClaro,
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: c.verde,
        inactiveTrackColor: c.laranjaClaro,
        thumbColor: c.verde,
        activeTickMarkColor: sobreVerde.withValues(alpha: 0.6),
        inactiveTickMarkColor: c.textoSuave,
      ),

      // Chave liga/desliga: agora o estado "desligado" fica bem visível.
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((estados) {
          if (estados.contains(WidgetState.selected)) return sobreVerde;
          return c.textoSuave;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((estados) {
          if (estados.contains(WidgetState.selected)) return c.verde;
          return c.borda;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((estados) {
          if (estados.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return c.textoSuave;
        }),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((estados) {
          if (estados.contains(WidgetState.selected)) return c.verde;
          return c.textoSecundario;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((estados) {
          if (estados.contains(WidgetState.selected)) return c.verde;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(sobreVerde),
        side: WidgetStateBorderSide.resolveWith(
          (estados) => BorderSide(color: c.textoSecundario, width: 2),
        ),
      ),
    );
  }
}