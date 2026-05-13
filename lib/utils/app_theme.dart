import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:own_holiday_app/utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = GoogleFonts.montserratTextTheme();

    return ThemeData(
      primaryColor: AppColors.primaryYellow,
      scaffoldBackgroundColor: AppColors.primaryWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryYellow,
        secondary: AppColors.primaryBlack,
        surface: AppColors.primaryWhite,
      ),
      fontFamily: GoogleFonts.montserrat().fontFamily,
      textTheme: base.copyWith(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlack,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlack,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryBlack,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.greyText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.primaryBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          elevation: 0,
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryYellow,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlack,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
      ),
    );
  }
}
