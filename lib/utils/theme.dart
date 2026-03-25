import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Vibrant Admin Colors from Screenshot
  static const Color primary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFFC084FC);
  static const Color sidebarBg = Color(0xFF0F172A);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color textMain = Color(0xFF1E293B);
  static const Color textDim = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF1F5F9),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleBanner = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
