import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum ConditionArrowDirection { up, steady, down }

ConditionArrowDirection conditionArrowDirectionFromScore(num score) {
  if (score >= 76) return ConditionArrowDirection.up;
  if (score >= 56) return ConditionArrowDirection.steady;
  return ConditionArrowDirection.down;
}

class ConditionArrowMark extends StatelessWidget {
  final ConditionArrowDirection? direction;
  final num? score;
  final double size;
  final bool framed;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const ConditionArrowMark({
    super.key,
    this.direction,
    this.score,
    this.size = 18,
    this.framed = true,
    this.color,
    this.padding = const EdgeInsets.all(6),
  }) : assert(direction != null || score != null);

  @override
  Widget build(BuildContext context) {
    final resolvedDirection = direction ?? conditionArrowDirectionFromScore(score!);
    final resolvedColor = color ?? _colorFor(resolvedDirection);
    final icon = _iconFor(resolvedDirection);

    final child = Icon(icon, size: size, color: resolvedColor);
    if (!framed) return child;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: resolvedColor.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: resolvedColor.withValues(alpha: 0.16),
            blurRadius: 18,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  static IconData _iconFor(ConditionArrowDirection direction) {
    switch (direction) {
      case ConditionArrowDirection.up:
        return Icons.north_rounded;
      case ConditionArrowDirection.steady:
        return Icons.north_east_rounded;
      case ConditionArrowDirection.down:
        return Icons.south_east_rounded;
    }
  }

  static Color _colorFor(ConditionArrowDirection direction) {
    switch (direction) {
      case ConditionArrowDirection.up:
        return AppColors.lanternGlow;
      case ConditionArrowDirection.steady:
        return AppColors.signalBlue;
      case ConditionArrowDirection.down:
        return AppColors.fire;
    }
  }
}

class FullConWordmark extends StatelessWidget {
  final String label;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool outlined;

  const FullConWordmark({
    super.key,
    this.label = 'FullCon',
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.outlined = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: outlined ? 0.06 : 0.0),
        borderRadius: BorderRadius.circular(999),
        border: outlined
            ? Border.all(color: Colors.white.withValues(alpha: 0.12))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ConditionArrowMark(
            direction: ConditionArrowDirection.up,
            size: 14,
            padding: EdgeInsets.all(4),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.84),
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
