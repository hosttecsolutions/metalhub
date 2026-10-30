import 'package:flutter/material.dart';

const green = Color(0xFF009C70);
const canvas = Color(0xFFF6F8FA);
const ink = Color(0xFF243C47);
const muted = Color(0xFF73838D);
const outline = Color(0xFFE2E7EC);
const paleGreen = Color(0xFFE8F6F0);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: green).copyWith(
    primary: green,
    surface: Colors.white,
    onSurface: ink,
    outline: outline,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: canvas,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: ink),
      bodySmall: TextStyle(fontSize: 12, color: muted, height: 1.5),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9DAAB3)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: green, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: green,
        side: const BorderSide(color: outline),
        textStyle: const TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: outline, space: 1),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xFF155D48),
    ),
  );
}
