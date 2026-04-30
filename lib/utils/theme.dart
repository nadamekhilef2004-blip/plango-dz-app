import 'package:flutter/material.dart';

class AppTheme {
  // Soft, Natural Color Palette (Beige & Sage Green)
  static const Color primaryColor = Color(0xFF6C7D76);      // Sage green
  static const Color secondaryColor = Color(0xFF91A8B0);    // Soft blue-grey
  static const Color accentColor = Color(0xFFA39C7C);       // Warm beige/gold
  static const Color accentLight = Color(0xFFC1D3C6);       // Light sage
  static const Color cardColor = Color(0xFFEBF2E8);         // Very soft beige/cream
  static const Color backgroundColor = Color(0xFFEBF2E8);   // Soft cream background
  static const Color textPrimary = Color(0xFF212423);       // Dark soft black
  static const Color textSecondary = Color(0xFF414836);     // Soft dark green
  static const Color textHint = Color(0xFF6C7D76);          // Sage green
  static const Color successColor = Color(0xFF6C7D76);
  static const Color warningColor = Color(0xFFA39C7C);
  static const Color errorColor = Color(0xFFE94560);        // Soft red/pink for errors
  
  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC1D3C6), Color(0xFFEBF2E8), Color(0xFFEBF2E8)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFEBF2E8)],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C7D76), Color(0xFF91A8B0)],
  );
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF212423)),
        titleTextStyle: TextStyle(
          color: Color(0xFF212423),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        hintStyle: TextStyle(color: textHint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFF212423), fontSize: 22, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Color(0xFF212423), fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFF414836), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFF414836), fontSize: 14),
        bodySmall: TextStyle(color: Color(0xFF6C7D76), fontSize: 12),
      ),
    );
  }
}
