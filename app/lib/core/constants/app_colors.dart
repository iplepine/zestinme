import 'package:flutter/material.dart';

/// ZestInMe 앱 색상 팔레트 - CSS 변수 기반
/// 레몬 테마의 풍부한 색상 시스템
class AppColors {
  // 기본 색상 (CSS 변수 기반)
  static const primary = Color(0xFFFFE135); // --primary
  static const primaryForeground = Color(0xFF2A2A00); // --primary-foreground
  static const secondary = Color(0xFFFFF8C4); // --secondary
  static const secondaryForeground = Color(
    0xFF2A2A00,
  ); // --secondary-foreground
  static const accent = Color(0xFFFFF59D); // --accent
  static const accentForeground = Color(0xFF2A2A00); // --accent-foreground
  static const muted = Color(0xFFFFFAEB); // --muted
  static const mutedForeground = Color(0xFF717182); // --muted-foreground
  static const destructive = Color(0xFFD4183D); // --destructive
  static const destructiveForeground = Color(
    0xFFFFFFFF,
  ); // --destructive-foreground

  // 배경 및 카드 색상
  static const background = Color(0xFFFFFFFF); // --background
  static const foreground = Color(0xFF2A2A00); // --foreground
  static const card = Color(0xFFFFFFFF); // --card
  static const cardForeground = Color(0xFF2A2A00); // --card-foreground
  static const popover = Color(0xFFFFFFFF); // --popover
  static const popoverForeground = Color(0xFF2A2A00); // --popover-foreground

  // 테두리 및 입력 색상
  static const border = Color(0x1A000000); // --border (rgba(0, 0, 0, 0.1))
  static const input = Color(0x00000000); // --input (transparent)
  static const inputBackground = Color(0xFFFFFAEB); // --input-background
  static const switchBackground = Color(0xFFCBCED4); // --switch-background
  static const ring = Color(0xFFFFE135); // --ring

  // 차트 색상 (그라데이션)
  static const chart1 = Color(0xFFFFE135); // --chart-1
  static const chart2 = Color(0xFFFFF176); // --chart-2
  static const chart3 = Color(0xFFFFCC02); // --chart-3
  static const chart4 = Color(0xFFF9A825); // --chart-4
  static const chart5 = Color(0xFFFF8F00); // --chart-5

  // 사이드바 색상
  static const sidebar = Color(0xFFFBFBFB); // --sidebar
  static const sidebarForeground = Color(0xFF2A2A00); // --sidebar-foreground
  static const sidebarPrimary = Color(0xFFFFE135); // --sidebar-primary
  static const sidebarPrimaryForeground = Color(
    0xFF2A2A00,
  ); // --sidebar-primary-foreground
  static const sidebarAccent = Color(0xFFFFF8C4); // --sidebar-accent
  static const sidebarAccentForeground = Color(
    0xFF2A2A00,
  ); // --sidebar-accent-foreground
  static const sidebarBorder = Color(0xFFEBEBEB); // --sidebar-border
  static const sidebarRing = Color(0xFFFFE135); // --sidebar-ring

  // 다크 모드 색상
  static const primaryDark = Color(0xFFFFE135); // primary (dark)
  static const primaryForegroundDark = Color(
    0xFF2A2A00,
  ); // primary-foreground (dark)
  static const backgroundDark = Color(0xFF252525); // oklch(0.145 0 0)
  static const foregroundDark = Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const cardDark = Color(0xFF252525); // oklch(0.145 0 0)
  static const cardForegroundDark = Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const secondaryDark = Color(0xFF4A4A00); // --secondary (dark)
  static const secondaryForegroundDark = Color(
    0xFFFFE135,
  ); // --secondary-foreground (dark)
  static const mutedDark = Color(0xFF444444); // oklch(0.269 0 0)
  static const mutedForegroundDark = Color(0xFFB5B5B5); // oklch(0.708 0 0)
  static const accentDark = Color(0xFF3A3A00); // --accent (dark)
  static const accentForegroundDark = Color(
    0xFFFFE135,
  ); // --accent-foreground (dark)
  static const destructiveDark = Color(0xFFE53E3E); // oklch(0.396 0.141 25.723)
  static const destructiveForegroundDark = Color(
    0xFFA23E3E,
  ); // oklch(0.637 0.237 25.331)
  static const borderDark = Color(0xFF444444); // oklch(0.269 0 0)
  static const inputDark = Color(0xFF444444); // oklch(0.269 0 0)
  static const sidebarDark = Color(0xFF343434); // oklch(0.205 0 0)
  static const sidebarForegroundDark = Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const sidebarAccentDark = Color(0xFF3A3A00); // --sidebar-accent (dark)
  static const sidebarAccentForegroundDark = Color(
    0xFFFFE135,
  ); // --sidebar-accent-foreground (dark)
  static const sidebarBorderDark = Color(0xFF444444); // oklch(0.269 0 0)

  // 반지름 값 (CSS 변수 기반)
  static const radius = 10.0; // --radius (0.625rem = 10px)
  static const radiusSm = 6.0; // --radius-sm (calc(var(--radius) - 4px))
  static const radiusMd = 8.0; // --radius-md (calc(var(--radius) - 2px))
  static const radiusLg = 10.0; // --radius-lg (var(--radius))
  static const radiusXl = 14.0; // --radius-xl (calc(var(--radius) + 4px))

  // 폰트 웨이트
  static const fontWeightNormal = FontWeight.w400; // --font-weight-normal
  static const fontWeightMedium = FontWeight.w500; // --font-weight-medium

  // 투명도 변형
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withOpacity(opacity);
  static Color accentWithOpacity(double opacity) => accent.withOpacity(opacity);
  static Color mutedWithOpacity(double opacity) => muted.withOpacity(opacity);

  // 그라데이션
  static const primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const chartGradient = LinearGradient(
    colors: [chart1, chart2, chart3, chart4, chart5],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const sidebarGradient = LinearGradient(
    colors: [sidebar, sidebarAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 역할별 색상 매핑
  static const Map<String, Color> roleColors = {
    'primary': primary,
    'secondary': secondary,
    'accent': accent,
    'muted': muted,
    'destructive': destructive,
    'success': accent, // 성공 상태는 accent 색상 사용
    'warning': chart4, // 경고는 chart4 색상 사용
    'info': chart2, // 정보는 chart2 색상 사용
    'neutral': mutedForeground, // 중립은 muted-foreground 사용
  };

  // 접근성을 위한 대비 색상
  static final Map<Color, Color> contrastColors = {
    primary: primaryForeground,
    secondary: secondaryForeground,
    accent: accentForeground,
    muted: mutedForeground,
    destructive: destructiveForeground,
    // 다크 모드
    secondaryDark: secondaryForegroundDark,
    accentDark: accentForegroundDark,
    mutedDark: mutedForegroundDark,
    destructiveDark: destructiveForegroundDark,
  };

  // 차트 색상 배열
  static const List<Color> chartColors = [
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
  ];

  // 사이드바 색상 매핑
  static const Map<String, Color> sidebarColors = {
    'background': sidebar,
    'foreground': sidebarForeground,
    'primary': sidebarPrimary,
    'primaryForeground': sidebarPrimaryForeground,
    'accent': sidebarAccent,
    'accentForeground': sidebarAccentForeground,
    'border': sidebarBorder,
    'ring': sidebarRing,
  };

  // 다크 모드 사이드바 색상 매핑
  static const Map<String, Color> sidebarDarkColors = {
    'background': sidebarDark,
    'foreground': sidebarForegroundDark,
    'primary': sidebarPrimary,
    'primaryForeground': sidebarPrimaryForeground,
    'accent': sidebarAccentDark,
    'accentForeground': sidebarAccentForegroundDark,
    'border': sidebarBorderDark,
    'ring': sidebarRing,
  };
  // Seeding Color Palette (Mind-Gardener Quadrants) - Trendy/Aesthetic
  static const seedingSun = Color(
    0xFFFFD166,
  ); // Top-Right (Energized): Sunglow - Warm & Inviting
  static const seedingFire = Color(
    0xFFEF476F,
  ); // Top-Left (Stressed): Paradise Pink - Urgent but Beautiful
  static const seedingRain = Color(
    0xFF118AB2,
  ); // Bottom-Left (Tired): Blue Green - Deep & Calming
  static const seedingGrass = Color(
    0xFF06D6A0,
  ); // Bottom-Right (Calm): Caribbean Green - Refreshing

  static const seedingTextShadow = Color(
    0x80000000,
  ); // Text Shadow for readability

  static final seedingCardBackground = const Color(
    0xFF1E1E1E,
  ).withValues(alpha: 0.95);
  static const seedingChipSelected = Color(0xFFffe135); // Seeding Sun Yellow
  static const seedingChipTextSelected = Colors.black;
}
