import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema premium dark mode para ClickforShine
/// Paleta: Preto Profundo (#000000), Cinza Grafite (#1A1A1A), Dourado (#D4AF37)
class AppTheme {
  // Cores da paleta
  static const Color _darkBackground = Color(0xFF000000);
  static const Color _darkSurface = Color(0xFF1A1A1A);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _cobaltBlue = Color(0xFF2E5EAA);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _grey = Color(0xFF8A8A8A);
  static const Color _lightGrey = Color(0xFFCCCCCC);

  /// Tema dark mode com glassmorphism e animações suaves
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Cores principais
      primaryColor: _gold,
      scaffoldBackgroundColor: _darkBackground,
      canvasColor: _darkBackground,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _white,
        ),
      ),

      // Tipografia
      textTheme: TextTheme(
        // Headlines
        displayLarge: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _white,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: _white,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _white,
        ),
        
        // Headlines
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _white,
        ),
        
        // Body
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _white,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _lightGrey,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _grey,
        ),
        
        // Labels
        labelLarge: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _gold,
        ),
      ),

      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: _darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _gold,
          side: const BorderSide(color: _gold, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _gold,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _gold, width: 2),
        ),
        hintStyle: GoogleFonts.montserrat(
          fontSize: 14,
          color: _grey,
        ),
        labelStyle: GoogleFonts.montserrat(
          fontSize: 14,
          color: _gold,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: Color(0xFF333333),
        thickness: 1,
        space: 16,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: _darkSurface,
        selectedColor: _gold,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _grey, width: 1),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkSurface,
        contentTextStyle: GoogleFonts.montserrat(
          fontSize: 14,
          color: _white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // BottomSheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }

  /// Cores para uso em widgets customizados
  static const Map<String, Color> colors = {
    'darkBackground': _darkBackground,
    'darkSurface': _darkSurface,
    'gold': _gold,
    'cobaltBlue': _cobaltBlue,
    'white': _white,
    'grey': _grey,
    'lightGrey': _lightGrey,
  };
}
