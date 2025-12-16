import 'package:flutter/material.dart';

class SleepBatteryWidget extends StatelessWidget {
  final double chargeLevel; // 0.0 to 1.0
  final VoidCallback onTap;

  const SleepBatteryWidget({
    super.key,
    required this.chargeLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color batteryColor;
    if (chargeLevel >= 0.9) {
      batteryColor = const Color(0xFF69F0AE); // Mint Green
    } else if (chargeLevel >= 0.7) {
      batteryColor = const Color(0xFFFFD740); // Amber
    } else if (chargeLevel > 0.0) {
      batteryColor = const Color(0xFFFF5252); // Red
    } else {
      batteryColor = Colors.grey.withOpacity(0.5); // Empty/Unknown
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: CustomPaint(
          size: const Size(28, 14), // Small battery icon size
          painter: BatteryPainter(
            chargeLevel: chargeLevel,
            color: batteryColor,
          ),
        ),
      ),
    );
  }
}

class BatteryPainter extends CustomPainter {
  final double chargeLevel;
  final Color color;

  BatteryPainter({required this.chargeLevel, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Battery Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width - 3, size.height),
      const Radius.circular(2),
    );

    // Battery Cap
    final capRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width - 2, size.height * 0.25, 2, size.height * 0.5),
      const Radius.circular(1),
    );

    // Draw Outline
    canvas.drawRRect(bodyRect, paint);
    canvas.drawRRect(capRect, Paint()..color = Colors.white.withOpacity(0.3));

    // Draw Fill
    if (chargeLevel > 0) {
      final fillWidth = (size.width - 5) * chargeLevel.clamp(0.0, 1.0);
      final fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(1.5, 1.5, fillWidth, size.height - 3),
        const Radius.circular(1),
      );
      canvas.drawRRect(fillRect, fillPaint);
    }

    // Bolt Icon (Overlay if charging or full - simple visual cue)
    // Optional: Add bolt if needed, keeping it simple for now.
  }

  @override
  bool shouldRepaint(covariant BatteryPainter oldDelegate) {
    return oldDelegate.chargeLevel != chargeLevel || oldDelegate.color != color;
  }
}
