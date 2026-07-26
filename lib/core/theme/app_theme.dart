import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xff6750a4), brightness: brightness);
    return ThemeData(useMaterial3: true, colorScheme: scheme, cardTheme: CardTheme(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))), inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(18))));
  }
}
