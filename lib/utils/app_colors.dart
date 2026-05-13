import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primaryYellow = Color(0xFFFFC107); // Amber - lighter yellow
  static const Color primaryBlack  = Color(0xFF1A1A1A); // Soft black
  static const Color primaryWhite  = Color(0xFFFFFFFF);

  // Accent / utility
  static const Color yellowLight   = Color(0xFFFFF8E1); // Very pale yellow background
  static const Color yellowMid     = Color(0xFFFFE082); // Mid yellow for accents
  static const Color greyText      = Color(0xFF8A8A8A);
  static const Color lightGrey     = Color(0xFFF5F5F5);
  static const Color borderGrey    = Color(0xFFE0E0E0);
  static const Color darkGrey      = Color(0xFF424242);

  static LinearGradient get yellowGradient => const LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFFE082)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
