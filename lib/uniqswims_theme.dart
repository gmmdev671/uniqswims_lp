import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniqSwimsTheme {
  // Paleta
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF121212);
  static const Color surfaceGrey = Color(0xFF1E1E1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);

  static const Color accentBlue = Color(0xFF4FC3F7);
  static const Color accentBlueHover = Color(0xFF81D4FA);

  // Reutilizáveis (se quiser chamar de fora)
  static TextStyle get displayLarge => GoogleFonts.montserrat(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: white,
        letterSpacing: -1.0,
      );

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: accentBlue,

      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: accentBlue,
        secondary: accentBlue,
        surface: surfaceGrey,
        onSurface: white,
        onPrimary: black,
      ),

      // Tipografia
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: white,
          letterSpacing: -1.0,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          color: white,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: white,
        ),
      ),

      // Ícones e AppBar
      iconTheme: const IconThemeData(color: white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(color: white), // fallback
      ),

      // Elevated Button (CTA) - com estados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return accentBlueHover;
              }
              return accentBlue;
            },
          ),
          foregroundColor: WidgetStateProperty.all<Color>(black),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          textStyle: WidgetStateProperty.all(GoogleFonts.montserrat(fontWeight: FontWeight.w700)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        ),
      ),

      // Outlined Button (links com borda branca) - com hover que troca a cor
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) return accentBlue;
            return white;
          }),
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(WidgetState.hovered)) return const BorderSide(color: accentBlue, width: 1.6);
            return const BorderSide(color: white, width: 1.5);
          }),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 32, vertical: 20)),
          textStyle: WidgetStateProperty.all(GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        ),
      ),

      // Dividers (linhas horizontais)
      dividerTheme: const DividerThemeData(color: white, thickness: 1, space: 40),

      // Card / Surface
      cardTheme: CardThemeData(
        color: surfaceGrey,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Input, Tooltip etc. (adicionar conforme precisar)
    );
  }
}