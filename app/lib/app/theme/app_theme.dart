import 'package:flutter/material.dart';

/// ZestInMe 앱 테마 - 레몬(활력) + 라임(안정) 색상 팔레트
class AppTheme {
  // 라이트 모드 색상
  static const _primary = Color(0xFFffe135); // 레몬 - CTA/하이라이트
  static const _primaryContainer = Color(0xFFFFF4B8); // 연한 레몬
  static const _secondary = Color(0xFF6CCB2C); // 라임 - 성공/안정
  static const _secondaryContainer = Color(0xFFEAF6D8); // 연한 라임
  static const _background = Color(0xFFFFFFFF); // 흰색
  static const _surface = Color(0xFFFFFFFF); // 흰색
  static const _error = Color(0xFFE53935); // 에러 레드
  static const _onPrimary = Color(0xFF101418); // 진한 잉크 (레몬 위 텍스트)
  static const _onSecondary = Color(0xFF0B1407); // 진한 녹색 (라임 위 텍스트)
  static const _onSurface = Color(0xFF1F2429); // 메인 텍스트
  static const _onBackground = Color(0xFF101418); // 배경 위 텍스트
  static const _onError = Color(0xFFFFFFFF); // 에러 위 텍스트
  static const _outline = Color(0xFFC3CAD3); // 테두리/구분선
  static const _surfaceVariant = Color(0xFFF8F9FA); // 카드 배경

  // 다크 모드 색상
  static const _primaryDark = Color(0xFFFFDB26); // 채도 낮춘 골드
  static const _primaryContainerDark = Color(0xFF2A2A1A); // 어두운 골드 배경
  static const _secondaryDark = Color(0xFF57B21F); // 어두운 라임
  static const _secondaryContainerDark = Color(0xFF1A2E0F); // 어두운 라임 배경
  static const _backgroundDark = Color(0xFF101418); // 어두운 배경
  static const _surfaceDark = Color(0xFF14181C); // 어두운 서피스
  static const _onPrimaryDark = Color(0xFF101418); // 골드 위 텍스트
  static const _onSecondaryDark = Color(0xFFE1E6EC); // 라임 위 텍스트
  static const _onSurfaceDark = Color(0xFFE1E6EC); // 어두운 서피스 위 텍스트
  static const _onBackgroundDark = Color(0xFFE1E6EC); // 어두운 배경 위 텍스트
  static const _outlineDark = Color(0xFF4A5568); // 어두운 테두리

  // 라이트 모드 ColorScheme
  static final ColorScheme colorScheme = ColorScheme(
    primary: _primary,
    primaryContainer: _primaryContainer,
    secondary: _secondary,
    secondaryContainer: _secondaryContainer,
    surface: _surface,
    surfaceVariant: _surfaceVariant,
    background: _background,
    error: _error,
    onPrimary: _onPrimary,
    onSecondary: _onSecondary,
    onSurface: _onSurface,
    onBackground: _onBackground,
    onError: _onError,
    outline: _outline,
    brightness: Brightness.light,
  );

  // 다크 모드 ColorScheme
  static final ColorScheme darkScheme = ColorScheme(
    primary: _primaryDark,
    primaryContainer: _primaryContainerDark,
    secondary: _secondaryDark,
    secondaryContainer: _secondaryContainerDark,
    surface: _surfaceDark,
    surfaceVariant: _surfaceDark,
    background: _backgroundDark,
    error: _error,
    onPrimary: _onPrimaryDark,
    onSecondary: _onSecondaryDark,
    onSurface: _onSurfaceDark,
    onBackground: _onBackgroundDark,
    onError: _onError,
    outline: _outlineDark,
    brightness: Brightness.dark,
  );

  // 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,

      // 앱바 테마
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 2,
        ),
      ),

      // 아웃라인 버튼 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
      ),

      // 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSecondary),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimary),
        disabledColor: colorScheme.outline.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 플로팅 액션 버튼 테마
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 스위치 테마
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.secondary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.secondaryContainer;
          }
          return colorScheme.outline.withOpacity(0.3);
        }),
      ),

      // 체크박스 테마
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.secondary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(colorScheme.onSecondary),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // 프로그레스 인디케이터 테마
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.outline.withOpacity(0.3),
        circularTrackColor: colorScheme.outline.withOpacity(0.3),
      ),

      // 아이콘 테마
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),

      // 텍스트 테마
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: colorScheme.onBackground, fontSize: 16),
        bodyMedium: TextStyle(color: colorScheme.onBackground, fontSize: 14),
        bodySmall: TextStyle(color: colorScheme.onBackground, fontSize: 12),
        labelLarge: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 다크 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkScheme,
      scaffoldBackgroundColor: darkScheme.background,

      // 앱바 테마
      appBarTheme: AppBarTheme(
        backgroundColor: darkScheme.surface,
        foregroundColor: darkScheme.onSurface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkScheme.primary,
          foregroundColor: darkScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 2,
        ),
      ),

      // 아웃라인 버튼 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkScheme.onSurface,
          side: BorderSide(color: darkScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // 텍스트 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: darkScheme.onSurface.withOpacity(0.7)),
        hintStyle: TextStyle(color: darkScheme.onSurface.withOpacity(0.5)),
      ),

      // 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: darkScheme.secondaryContainer,
        selectedColor: darkScheme.primaryContainer,
        labelStyle: TextStyle(color: darkScheme.onSecondary),
        secondaryLabelStyle: TextStyle(color: darkScheme.onPrimary),
        disabledColor: darkScheme.outline.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: darkScheme.outline.withOpacity(0.3)),
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        color: darkScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 플로팅 액션 버튼 테마
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkScheme.primary,
        foregroundColor: darkScheme.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 스위치 테마
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkScheme.secondary;
          }
          return darkScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkScheme.secondaryContainer;
          }
          return darkScheme.outline.withOpacity(0.3);
        }),
      ),

      // 체크박스 테마
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkScheme.secondary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(darkScheme.onSecondary),
        side: BorderSide(color: darkScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // 프로그레스 인디케이터 테마
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: darkScheme.primary,
        linearTrackColor: darkScheme.outline.withOpacity(0.3),
        circularTrackColor: darkScheme.outline.withOpacity(0.3),
      ),

      // 아이콘 테마
      iconTheme: IconThemeData(color: darkScheme.onSurface, size: 24),

      // 텍스트 테마
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: darkScheme.onBackground, fontSize: 16),
        bodyMedium: TextStyle(color: darkScheme.onBackground, fontSize: 14),
        bodySmall: TextStyle(color: darkScheme.onBackground, fontSize: 12),
        labelLarge: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: darkScheme.onBackground,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),

      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkScheme.primary,
        contentTextStyle: TextStyle(color: darkScheme.onPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
