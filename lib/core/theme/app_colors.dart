import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE50914); 
  static const Color primaryDark = Color(0xFFC53030);
  static const Color primaryLight = Color(0xFFFC8181);

  static const Color background = Color(0xFF090909); 
  static const Color surface = Color(0xFF1A1A1A); 
  static const Color cardBackground = Color(0xFF2D2D2D);
  static const Color inputBackground = Color(0xFF2A2A2A);

  static const Color textPrimary = Color(0xFFFFFFFF); 
  static const Color textSecondary = Color(0xFFB3B3B3); 
  static const Color textHint = Color(0xFF666666);
  static const Color textDisabled = Color(0xFF4A4A4A);

  static const Color success = Color(0xFF38A169);
  static const Color error = Color(0xFFE50914);
  static const Color warning = Color(0xFFD69E2E);
  static const Color info = Color(0xFF3182CE);

  static const Color google = Color(0xFFFFFFFF);
  static const Color apple = Color(0xFFFFFFFF);
  static const Color facebook = Color(0xFFFFFFFF);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1AFFFFFF);
  static const Color shadowDark = Color(0x40000000);
}
