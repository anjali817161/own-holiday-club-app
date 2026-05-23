import 'package:flutter/material.dart';

class AppColors {
  // ── Colors ──────────────────────────────────────────────────────
  static const Color primaryYellow  = Color(0xFFFFC700); // Premium Gold/Yellow
  static const Color softYellow     = Color(0xFFFFF9E6); 
  static const Color creamWhite     = Color(0xFFFFFDF8); 
  static const Color brownAccent    = Color(0xFF1A1A1A); // Neutral dark/black instead of brown
  static const Color primaryWhite   = Color(0xFFFFFFFF); 

  // ── Semantic aliases ────────────────────────────────────
  static const Color primaryBlack   = Color(0xFF1A1A1A); // Actual dark neutral
  static const Color darkText       = Color(0xFF1A1A1A); 
  static const Color bodyText       = Color(0xFF4A4A4A); 
  static const Color greyText       = Color(0xFF757575); 
  static const Color lightGrey      = Color(0xFFF5F5F5); 
  static const Color borderGrey     = Color(0xFFE0E0E0); 

  // ── Surfaces ─────────────────────────────────────────────────────────────
  static const Color scaffoldBg     = Color(0xFFFAFAFA); 
  static const Color cardBg         = Color(0xFFFFFFFF); 
  static const Color drawerBg       = Color(0xFF1A1A1A); 

  // ── Gradients ─────────────────────────────────────────────────────────────
  static LinearGradient get yellowGradient => const LinearGradient(
    colors: [Color(0xFFFFC700), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get warmGradient => const LinearGradient(
    colors: [Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
