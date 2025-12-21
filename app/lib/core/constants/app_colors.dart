import 'package:flutter/material.dart';

/// ZestInMe 앱 색상 팔레트 - Atmospheric Realism
/// 현실적인 물리 법칙 위에 '공기감'과 '깊이감'을 더한 스타일
class AppColors {
  // --- 1. Core Palette (Atmospheric Realism) ---
  static const voidBlack = Color(0xFF050505); // 깊은 배경 (Main Background)
  static const glassSurface = Color(0xFF14181C); // 유리 질감 베이스 (Surface)
  static const lemonPrimary = Color(0xFFFFE135); // 핵심 액션 컬러 (Lemon)
  static const limeSecondary = Color(0xFF6CCB2C); // 안정 및 수심 컬러 (Lime)

  // --- 2. Legacy & CSS Compatibility Aliases ---
  static const primary = lemonPrimary;
  static const primaryForeground = Color(0xFF101418);
  static const secondary = Color(0xFFFFF8C4);
  static const secondaryForeground = Color(0xFF101418);
  static const accent = Color(0xFFFFF59D);
  static const accentForeground = Color(0xFF101418);
  static const muted = Color(0xFFFFFAEB);
  static const mutedForeground = Color(0xFF717182);
  static const destructive = Color(0xFFD4183D);
  static const destructiveForeground = Color(0xFFFFFFFF);

  // --- 3. UI Layout Colors ---
  static const background = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF101418);
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF101418);
  static const border = Color(0x1A000000);
  static const inputBackground = Color(0xFFFFFAEB);

  // Dark Mode Layout Tokens
  static const backgroundDark = voidBlack;
  static const foregroundDark = Color(0xFFFBFBFB);
  static const cardDark = glassSurface;
  static const cardForegroundDark = Color(0xFFFBFBFB);
  static const borderDark = Color(0xFF444444);

  // --- 4. Chart & Gradients ---
  static const chart1 = lemonPrimary;
  static const chart2 = Color(0xFFFFF176);
  static const chart3 = Color(0xFFFFCC02);
  static const chart4 = Color(0xFFF9A825);
  static const chart5 = Color(0xFFFF8F00);

  static const List<Color> chartColors = [
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
  ];

  static const chartGradient = LinearGradient(
    colors: [chart1, chart2, chart3, chart4, chart5],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- 5. Status & Atmospheric Colors ---
  static const sunlight = Color(0xFFFFD166);
  static const fire = Color(0xFFEF476F);
  static const ocean = Color(0xFF118AB2);
  static const meadow = Color(0xFF06D6A0);

  // Seeding Color Palette (Mind-Gardener Quadrants)
  static const seedingSun = sunlight;
  static const seedingFire = fire;
  static const seedingRain = ocean;
  static const seedingGrass = meadow;
  static const seedingTextShadow = Color(0x80000000);
  static final seedingCardBackground = const Color(
    0xFF1E1E1E,
  ).withOpacity(0.95);
  static const seedingChipSelected = lemonPrimary;
  static const seedingChipTextSelected = Colors.black;
  static const seedingChipIdleBackground = voidBlack;
  static final seedingChipIdleBorder = Colors.white.withOpacity(0.1);
  static const seedingChipIdleText = Colors.white;
  static const seedingActionButtonBackground = seedingChipSelected;
  static const seedingActionButtonText = Colors.black;

  // --- 6. Design Tokens (Radius, Weights) ---
  static const radiusLg = 28.0; // Atmospheric Realism: 더욱 부드러운 곡률
  static const radiusMd = 16.0;
  static const radiusSm = 8.0;

  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
}
