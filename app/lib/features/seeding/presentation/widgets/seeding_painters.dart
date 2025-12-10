import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class SoilPainter extends CustomPainter {
  final double valence;
  final double arousal;
  final Offset center;

  SoilPainter({
    required this.valence,
    required this.arousal,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base background (Deep neutral to make colors pop)
    canvas.drawRect(
      rect,
      Paint()..color = const Color(0xFF1A1A1A), // Dark charcoal base
    );

    // 1. Draw 4 Corner Radial Gradients (Base Layer)
    final double radius = size.longestSide; // Full coverage
    final Color cSun = AppColors.seedingSun.withValues(alpha: 0.7);
    final Color cFire = AppColors.seedingFire.withValues(alpha: 0.7);
    final Color cRain = AppColors.seedingRain.withValues(alpha: 0.7);
    final Color cGrass = AppColors.seedingGrass.withValues(alpha: 0.7);
    final Color cTransparent = Colors.transparent;

    // Helper to draw corner gradient
    void drawCorner(Offset center, Color color) {
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [color, cTransparent],
          [
            0.2,
            1.0,
          ], // Keep color solid for first 20% (as requested), then fade
        )
        ..blendMode = BlendMode.srcOver;
      canvas.drawRect(rect, paint);
    }

    // Order: Draw all 4.
    drawCorner(Offset(size.width, 0), cSun); // Top-Right
    drawCorner(Offset(0, 0), cFire); // Top-Left
    drawCorner(Offset(0, size.height), cRain); // Bottom-Left
    drawCorner(Offset(size.width, size.height), cGrass); // Bottom-Right

    // 2. Dynamic Overlay: Spread active quadrant color based on intensity
    final double intensity = (valence * valence + arousal * arousal).clamp(
      0.0,
      1.0,
    );

    // Determine active color
    Color activeColor;
    if (arousal > 0) {
      if (valence > 0) {
        activeColor = AppColors.seedingSun;
      } else {
        activeColor = AppColors.seedingFire;
      }
    } else {
      if (valence > 0) {
        activeColor = AppColors.seedingGrass;
      } else {
        activeColor = AppColors.seedingRain;
      }
    }

    // Apply overlay with smooth fade-in
    final overlayPaint = Paint()
      ..color = activeColor.withValues(alpha: intensity * 0.9);
    canvas.drawRect(rect, overlayPaint);

    // 3. Vignette to focus center (kept for aesthetic depth)
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
        stops: const [0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant SoilPainter oldDelegate) {
    return oldDelegate.valence != valence ||
        oldDelegate.arousal != arousal ||
        oldDelegate.center != center;
  }
}

class GuidePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final AppLocalizations l10n;

  GuidePainter({
    required this.center,
    required this.radius,
    required this.l10n,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Circle (Thinner, more subtle)
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, circlePaint);

    // Draw Crosshairs with Gradient Fades
    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.white.withValues(alpha: 0.0), // Center: Transparent
          Colors.white.withValues(alpha: 0.2), // Mid: Visible
          Colors.white.withValues(alpha: 0.0), // Edge: Transparent
        ],
        [0.0, 0.5, 1.0], // Stops
      );

    // Horizontal Line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      linePaint,
    );

    // Vertical Line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      linePaint,
    );

    // Draw Quadrant Labels (Corners of the map)
    final double leftX = size.width * 0.25;
    final double rightX = size.width * 0.75;
    final double topY = size.height * 0.18;
    final double bottomY = size.height * 0.82;

    // Top-Right: Energized
    _drawText(
      canvas,
      l10n.seeding_quadrant_energized,
      Offset(rightX, topY),
      isLarge: true,
    );

    // Top-Left: Stressed
    _drawText(
      canvas,
      l10n.seeding_quadrant_stress,
      Offset(leftX, topY),
      isLarge: true,
    );

    // Bottom-Left: Tired
    _drawText(
      canvas,
      l10n.seeding_quadrant_tired,
      Offset(leftX, bottomY),
      isLarge: true,
    );

    // Bottom-Right: Calm
    _drawText(
      canvas,
      l10n.seeding_quadrant_calm,
      Offset(rightX, bottomY),
      isLarge: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position, {
    bool isLarge = false,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.8),
        fontSize: isLarge ? 16 : 14,
        fontWeight: isLarge ? FontWeight.w600 : FontWeight.w400,
        height: 1.0,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Center the text at position
    final offset = Offset(
      position.dx - (textPainter.width / 2),
      position.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
