import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// ZestInMe 앱 테마 - Atmospheric Realism
class AppTheme {
  // Legacy Aliases for Component Support
  static Color get primaryColor => AppColors.lemonPrimary;
  static Color get secondaryColor => AppColors.limeSecondary;
  static TextTheme get textTheme => lightTheme.textTheme;

  // --- 1. Color Schemes ---

  static final ColorScheme lightScheme = ColorScheme.light(
    primary: AppColors.lemonPrimary,
    onPrimary: AppColors.primaryForeground,
    secondary: AppColors.limeSecondary,
    onSecondary: AppColors.secondaryForeground,
    surface: AppColors.card,
    onSurface: AppColors.cardForeground,
    background: AppColors.background,
    onBackground: AppColors.foreground,
    error: AppColors.destructive,
    onError: AppColors.destructiveForeground,
    outline: AppColors.border,
  );

  static final ColorScheme darkScheme = ColorScheme.dark(
    primary: AppColors.lemonPrimary,
    onPrimary: AppColors.voidBlack,
    secondary: AppColors.limeSecondary,
    onSecondary: AppColors.voidBlack,
    surface: AppColors.glassSurface,
    onSurface: AppColors.foregroundDark,
    background: AppColors.voidBlack,
    onBackground: AppColors.foregroundDark,
    error: AppColors.fire,
    onError: Colors.white,
    outline: AppColors.borderDark,
  );

  // --- 2. Themes ---

  static ThemeData get lightTheme => _buildTheme(lightScheme);
  static ThemeData get darkTheme => _buildTheme(darkScheme);

  static ThemeData _buildTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: isDark ? 0 : 2,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusSm),
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? scheme.surface.withOpacity(0.5) : scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          borderSide: BorderSide(color: scheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppColors.voidBlack
            : scheme.outline.withOpacity(0.1),
        selectedColor: scheme.primary,
        labelStyle: TextStyle(
          color: isDark ? Colors.white : scheme.onSurface,
          fontSize: 14,
        ),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
        ),
        side: BorderSide(color: scheme.outline.withOpacity(0.2)),
      ),

      // Text Theme
      textTheme: _buildTextTheme(scheme),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        color: scheme.onBackground,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: scheme.onBackground,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: scheme.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        color: scheme.onBackground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: scheme.onBackground,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: scheme.onBackground,
        fontSize: 14,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        color: scheme.onBackground,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
