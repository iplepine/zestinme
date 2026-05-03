import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Full Condition 앱의 공통 표면 스타일
class ZestStyles {
  static BoxDecoration glassDecoration({
    Color? color,
    double? blur,
    double? opacity,
    BorderRadius? borderRadius,
    bool showBorder = true,
  }) {
    return BoxDecoration(
      color: (color ?? AppColors.glassSurface).withValues(
        alpha: opacity ?? AppColors.glassOpacity,
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(AppColors.radiusMd),
      border: showBorder
          ? Border.all(
              color: Colors.white.withValues(alpha: AppColors.glassBorderOpacity),
              width: 1,
            )
          : null,
    );
  }

  static List<BoxShadow> glowingShadow({
    Color? color,
    double spread = 2.0,
    double blur = 15.0,
  }) {
    return [
      BoxShadow(
        color: (color ?? AppColors.lemonPrimary).withValues(alpha: 0.3),
        spreadRadius: spread,
        blurRadius: blur,
        offset: const Offset(0, 10),
      ),
    ];
  }
}

class ZestGlassCard extends StatelessWidget {
  final Widget child;
  final double? blur;
  final double? opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool showBorder;

  const ZestGlassCard({
    super.key,
    required this.child,
    this.blur,
    this.opacity,
    this.borderRadius,
    this.padding,
    this.margin,
    this.color,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppColors.radiusMd),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur ?? AppColors.glassBlur,
            sigmaY: blur ?? AppColors.glassBlur,
          ),
          child: Container(
            padding: padding,
            decoration: ZestStyles.glassDecoration(
              color: color,
              opacity: opacity,
              borderRadius: borderRadius,
              showBorder: showBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
