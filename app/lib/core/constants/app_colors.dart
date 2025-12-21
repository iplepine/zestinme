import 'package:flutter/material.dart';

/// ZestInMe 앱 색상 팔레트 - Atmospheric Realism
/// 현실적인 물리 법칙 위에 '공기감'과 '깊이감'을 더한 스타일
class AppColors {
  // --- 1. Core Palette (Midnight Mist) ---
  static const midnightDeep = Color(0xFF0A121A); // Deep Indigo Background
  static const mistySurface = Color(0xFF1A262F); // Misty Teal-Grey Surface
  static const lanternGlow = Color(0xFFFDF0D5); // Warm Lantern Light
  static const spiritTeal = Color(0xFF80DED9); // Ethereal Nature Glow

  // --- 2. Atmospheric Effects ---
  static const glassBlur = 24.0; // Increased for 'Foggy' feel
  static const glassOpacity = 0.6;
  static const glassBorderOpacity = 0.12; // Slightly more defined misty border

  static const lanternGlowLight = Color(0x60FDF0D5);
  static const spiritTealGlow = Color(0x4080DED9);

  static List<BoxShadow> ambientGlow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.2), // Slightly stronger for mist penetration
      blurRadius: 30, // Broader spread
      spreadRadius: 4,
    ),
  ];

  // --- 3. Semantic Layout Aliases ---
  // Dark Theme (Midnight Mist)
  static const backgroundDark = midnightDeep;
  static const foregroundDark = Color(0xFFE2E8F0);
  static const cardDark = mistySurface;
  static const borderDark = Color(0x1F80DED9); // Teal-tinted border

  // Light Theme (Soft Frost)
  static const backgroundLight = Color(0xFFF5F7FA);
  static const foregroundLight = Color(0xFF101418);
  static const cardLight = Color(0xE6FFFFFF);
  static const borderLight = Color(0x1A000000);

  // --- 4. Seeding Mood Quadrants (Misty Variants) ---
  static const sunlight = Color(0xFFFFD166);
  static const fire = Color(0xFFEF476F);
  static const ocean = Color(0xFF118AB2);
  static const meadow = Color(0xFF06D6A0);

  // Quadrant Aliases
  static const seedingSun = sunlight;
  static const seedingFire = fire;
  static const seedingRain = ocean;
  static const seedingGrass = meadow;

  // --- 5. Component Specific Tokens ---
  static const primaryButton = lanternGlow; // Warm highlight
  static const primaryButtonText = midnightDeep;

  static const chipSelected = spiritTeal; // Ethereal selection
  static const chipSelectedText = midnightDeep;
  static const chipIdle = Color(0x4D0A121A);
  static const chipIdleBorder = Color(0x3380DED9);
  static const chipIdleText = Colors.white70;

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
    Color(0xFFFFF176),
    Color(0xFFFFCC02),
    Color(0xFFF9A825),
    Color(0xFFFF8F00),
  ];

  // Design Tokens
  static const radiusLg = 28.0;
  static const radiusMd = 16.0;
  static const radiusSm = 8.0;

  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightBold = FontWeight.w700;
}
