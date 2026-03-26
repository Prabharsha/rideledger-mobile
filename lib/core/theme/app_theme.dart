import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// App theme definitions
class AppTheme {
  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        background: AppColors.lightBg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.darkText,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.darkText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.darkText,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.mutedText,
        ),
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.darkBg,
        secondary: AppColors.accentLight,
        onSecondary: AppColors.darkBg,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        background: AppColors.darkBg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.lightText,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.darkBg,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.lightText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.lightText,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.mutedText,
        ),
      ),
    );
  }

  /// Dashboard (motorcycle instrument panel) theme - always dark
  static ThemeData get dashboardTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.dashboardAccent,
      scaffoldBackgroundColor: AppColors.dashboardBg,
      colorScheme: ColorScheme.dark(
        primary: AppColors.dashboardAccent,
        onPrimary: AppColors.dashboardBg,
        surface: AppColors.darkSurfaceVariant,
        error: AppColors.error,
        background: AppColors.dashboardBg,
      ),
    );
  }
}
