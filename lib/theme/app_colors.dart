import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color orangePrimary = Color(0xFFFF8A65);
  static const Color orangeDark = Color(0xFFE64A19);
  
  static const Color bluePrimary = Color(0xFF42A5F5);
  static const Color blueDark = Color(0xFF1565C0);
  
  static const Color greenPrimary = Color(0xFF66BB6A);
  static const Color greenDark = Color(0xFF2E7D32);
  
  static const Color purplePrimary = Color(0xFFAB47BC);
  static const Color purpleDark = Color(0xFF6A1B9A);
  
  static const Color tealPrimary = Color(0xFF80CBC4);
  static const Color destructiveRed = Color(0xFFD32F2F);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF5F5F7);
  static const Color cardBackgroundWhite = Colors.white;
  static const Color cardBackgroundGrey = Color(0xFFF5F5F7);
  static const Color dividerGrey = Color(0xFFE0E0E0);
  static const Color greyBackground = Color(0xFFF0F0F0);
  
  // Text Colors
  static const Color textDark = Color(0xFF101828);
  static const Color textLight = Colors.white;
  static const Color textGrey = Colors.black54;
  static const Color textLightGrey = Colors.white70;

  // Number Colors
  static const Color numberBlueDark = Color(0xFF1565C0);
  static const Color numberBlueMid = Color(0xFF64B5F6);
  static const Color numberBlueLight = Color(0xFFBBDEFB);

  // Helper gradients
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orangeDark, orangePrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [blueDark, bluePrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [greenDark, greenPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleDark, purplePrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient whiteGradient = LinearGradient(
    colors: [cardBackgroundWhite, greyBackground],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Theme Helpers
  static LinearGradient getEventGradient(String category) {
    switch (category.toLowerCase()) {
      case 'orange': return orangeGradient;
      case 'blue': return blueGradient;
      case 'green': return greenGradient;
      case 'purple': return purpleGradient;
      case 'white': return whiteGradient;
      default: return whiteGradient;
    }
  }

  static bool isDarkTheme(String category) {
    return category.toLowerCase() != 'white';
  }

  static Color getThemePrimaryColor(String category) {
    switch (category.toLowerCase()) {
      case 'orange': return orangePrimary;
      case 'blue': return bluePrimary;
      case 'green': return greenPrimary;
      case 'purple': return purplePrimary;
      case 'white': return greyBackground;
      default: return greyBackground;
    }
  }
}
