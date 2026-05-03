import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Full Condition 앱 테마
class AppTheme {
  // Legacy Aliases for Component Support
  static Color get primaryColor => AppColors.lemonPrimary;
  static Color get secondaryColor => AppColors.limeSecondary;
  static TextTheme get textTheme => lightTheme.textTheme;

  // --- 1. Color Schemes ---

  static final ColorScheme lightScheme = ColorScheme.light(
    primary: AppColors.lanternGlow,
    onPrimary: Colors.white,
    secondary: AppColors.spiritTeal,
    onSecondary: AppColors.midnightDeep,
    surface: AppColors.cardLight,
    onSurface: AppColors.foregroundLight,
    error: AppColors.fire,
    onError: Colors.white,
    outline: AppColors.borderLight,
  );

  static final ColorScheme darkScheme = ColorScheme.dark(
    primary: AppColors.lanternGlow,
    onPrimary: Colors.white,
    secondary: AppColors.spiritTeal,
    onSecondary: AppColors.midnightDeep,
    surface: AppColors.mistySurface,
    onSurface: AppColors.foregroundDark,
    error: AppColors.fire,
    onError: Colors.white,
    outline: AppColors.borderDark,
    surfaceContainerHighest: AppColors.midnightDeep,
  );

  // --- 2. Themes ---

  static ThemeData get lightTheme => _buildTheme(lightScheme);
  static ThemeData get darkTheme => _buildTheme(darkScheme);

  static ThemeData _buildTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
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
          elevation: 0,
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? scheme.surface.withValues(alpha: 0.9) : scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppColors.mistySurface
            : scheme.outline.withValues(alpha: 0.1),
        selectedColor: scheme.primary,
        labelStyle: TextStyle(
          color: isDark ? Colors.white : scheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
        ),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
      ),

      // List Tile (Robust to text scaling)
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        iconColor: scheme.onSurface.withValues(alpha: 0.7),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),

      // Text Theme
      textTheme: _buildTextTheme(scheme),
      dividerColor: scheme.outline.withValues(alpha: 0.2),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        color: scheme.onSurface,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      displayMedium: TextStyle(
        color: scheme.onSurface,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      headlineMedium: TextStyle(
        color: scheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        color: scheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: scheme.onSurface,
        fontSize: 16,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        color: scheme.onSurface,
        fontSize: 14,
        height: 1.45,
      ),
      labelLarge: TextStyle(
        color: scheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
