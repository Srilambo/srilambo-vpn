import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand colors ──────────────────────────────────────────
  static const Color vpnGreen      = Color(0xFF00E676);
  static const Color vpnGreenDark  = Color(0xFF00C853);
  static const Color vpnBlue       = Color(0xFF00B0FF);
  static const Color vpnRed        = Color(0xFFFF5252);
  static const Color vpnOrange     = Color(0xFFFF9100);

  // ── Backgrounds ───────────────────────────────────────────
  static const Color bgDeep        = Color(0xFF080C14);
  static const Color bgCard        = Color(0xFF0F1629);
  static const Color bgElevated    = Color(0xFF161D35);
  static const Color bgSurface     = Color(0xFF1C2540);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFEAECF5);
  static const Color textSecondary = Color(0xFF8A90AC);
  static const Color textHint      = Color(0xFF4E5472);

  // ── Status ────────────────────────────────────────────────
  static const Color connected     = Color(0xFF00E676);
  static const Color connecting    = Color(0xFFFFD600);
  static const Color disconnected  = Color(0xFF4E5472);
  static const Color error         = Color(0xFFFF5252);

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF080C14), Color(0xFF0F1629), Color(0xFF161D35)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF131A30), Color(0xFF0D1525)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Theme ─────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final interTextTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge:  TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        headlineMedium:TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium:   TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge:     TextStyle(color: textPrimary),
        bodyMedium:    TextStyle(color: textSecondary),
        labelLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDeep,
      textTheme: interTextTheme,

      colorScheme: const ColorScheme.dark(
        primary: vpnGreen,
        onPrimary: bgDeep,
        primaryContainer: Color(0xFF003020),
        secondary: vpnBlue,
        onSecondary: bgDeep,
        surface: bgCard,
        onSurface: textPrimary,
        surfaceContainerHighest: bgElevated,
        error: vpnRed,
        outline: Color(0xFF2A3050),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: bgDeep,
        foregroundColor: textPrimary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: bgDeep,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E2A45), width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vpnGreen,
          foregroundColor: bgDeep,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: vpnGreen,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3050)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A3050)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: vpnGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: vpnRed),
        ),
        labelStyle: GoogleFonts.inter(color: textSecondary),
        hintStyle:  GoogleFonts.inter(color: textHint),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF1E2A45),
        thickness: 1,
      ),
    );
  }
}
