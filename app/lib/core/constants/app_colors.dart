import 'package:flutter/material.dart';

/// Full Condition 브랜드 팔레트
/// 선명한 상태 신호와 집중감 있는 다크 UI를 위한 토큰
class AppColors {
  // --- 1. Core Palette ---
  static const midnightDeep = Color(0xFF09111F);
  static const mistySurface = Color(0xFF121C31);
  static const lanternGlow = Color(0xFFFF6B4A);
  static const spiritTeal = Color(0xFF59E0C5);
  static const signalBlue = Color(0xFF7FB2FF);
  static const warmSurface = Color(0xFFF7F2EC);

  // --- 2. Shared Effects ---
  static const glassBlur = 18.0;
  static const glassOpacity = 0.78;
  static const glassBorderOpacity = 0.14;

  static const lanternGlowLight = Color(0x66FF6B4A);
  static const spiritTealGlow = Color(0x4059E0C5);

  static List<BoxShadow> ambientGlow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.18),
      blurRadius: 28,
      spreadRadius: 2,
    ),
  ];

  // --- 3. Semantic Aliases ---
  static const backgroundDark = midnightDeep;
  static const foregroundDark = Color(0xFFF4F7FB);
  static const cardDark = mistySurface;
  static const borderDark = Color(0x336B86B4);

  static const backgroundLight = warmSurface;
  static const foregroundLight = Color(0xFF151A24);
  static const cardLight = Color(0xFFFDFBF8);
  static const borderLight = Color(0x1F15243A);

  // --- 4. State Colors ---
  static const sunlight = Color(0xFFFFB34D);
  static const fire = Color(0xFFFF5B5B);
  static const ocean = signalBlue;
  static const meadow = spiritTeal;

  // Quadrant Aliases
  static const seedingSun = sunlight;
  static const seedingFire = fire;
  static const seedingRain = ocean;
  static const seedingGrass = meadow;

  // --- 5. Component Tokens ---
  static const primaryButton = lanternGlow;
  static const primaryButtonText = Colors.white;

  static const chipSelected = spiritTeal;
  static const chipSelectedText = midnightDeep;
  static const chipIdle = Color(0x33121C31);
  static const chipIdleBorder = Color(0x337FB2FF);
  static const chipIdleText = Color(0xFFD6E0F0);

  // --- 6. Legacy / Compatibility Aliases ---
  static const voidBlack = midnightDeep;
  static const glassSurface = mistySurface;
  static const lemonPrimary = lanternGlow;
  static const limeSecondary = spiritTeal;

  static const primary = lanternGlow;
  static const primaryForeground = midnightDeep;
  static const secondary = spiritTeal;
  static const secondaryForeground = midnightDeep;
  static const accent = spiritTeal;
  static const destructive = fire;
  static const border = borderLight;
  static const foreground = foregroundLight;
  static const mutedForeground = Color(0xFF718096);

  // --- 7. Chart & Data Visuals ---
  static const List<Color> chartColors = [
    lemonPrimary,
    spiritTeal,
    signalBlue,
    Color(0xFFFFA770),
    Color(0xFFB6C8FF),
  ];

  // Design Tokens
  static const radiusLg = 28.0;
  static const radiusMd = 16.0;
  static const radiusSm = 8.0;

  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightBold = FontWeight.w700;
}
