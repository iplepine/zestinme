import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractiveMoonTimeDial extends StatefulWidget {
  final DateTime bedTime;
  final DateTime wakeTime;
  final ValueChanged<DateTime> onBedTimeChanged;
  final ValueChanged<DateTime> onWakeTimeChanged;

  const InteractiveMoonTimeDial({
    super.key,
    required this.bedTime,
    required this.wakeTime,
    required this.onBedTimeChanged,
    required this.onWakeTimeChanged,
  });

  @override
  State<InteractiveMoonTimeDial> createState() =>
      _InteractiveMoonTimeDialState();
}

class _InteractiveMoonTimeDialState extends State<InteractiveMoonTimeDial> {
  _DragMode _dragMode = _DragMode.none;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final center = Offset(size.width / 2, size.height / 2);

        return GestureDetector(
          onPanStart: (details) => _handlePanStart(details, center),
          onPanUpdate: (details) => _handlePanUpdate(details, center),
          onPanEnd: (_) {
            if (_dragMode != _DragMode.none) {
              HapticFeedback.mediumImpact();
            }
            setState(() => _dragMode = _DragMode.none);
          },
          child: CustomPaint(
            size: size,
            painter: MoonTimeDialPainter(
              bedTime: widget.bedTime,
              wakeTime: widget.wakeTime,
              baseColor: Colors.white.withValues(alpha: 0.3),
              activeColor: const Color(0xFF9575CD),
              handlerColor: const Color(0xFFD1C4E9),
            ),
          ),
        );
      },
    );
  }

  void _handlePanStart(DragStartDetails details, Offset center) {
    final touchPos = details.localPosition;
    final touchAngle = _coordToAngle(touchPos, center);

    final bedAngle = _dateTimeToAngle(widget.bedTime);
    final wakeAngle = _dateTimeToAngle(widget.wakeTime);

    // Check distance in angular space
    // Need minimum distance check? Or strict tolerance?
    // Let's use simple angular distance.
    final distBed = _angularDistance(touchAngle, bedAngle);
    final distWake = _angularDistance(touchAngle, wakeAngle);

    // Threshold (e.g. 1.2 radians approx 68 degrees for maximum touch area)
    const threshold = 1.2;

    if (distBed < threshold && distBed < distWake) {
      setState(() => _dragMode = _DragMode.bed);
    } else if (distWake < threshold) {
      setState(() => _dragMode = _DragMode.wake);
    } else {
      setState(() => _dragMode = _DragMode.none);
    }

    if (_dragMode != _DragMode.none) {
      HapticFeedback.lightImpact();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, Offset center) {
    if (_dragMode == _DragMode.none) return;

    final touchPos = details.localPosition;
    final touchAngle = _coordToAngle(touchPos, center);

    // Convert touch angle to "minutes from 12:00" on face (0..720)
    // Angle -pi/2 is 12:00.
    // Normalized angle starting from -pi/2 going clockwise.
    // _coordToAngle returns -pi to pi.
    // Right (0) -> 0. Top (-pi/2) -> -pi/2.
    // We want to map Top(-pi/2) -> 0 minutes.
    // Formula: minutes = ((angle + pi/2) / 2pi) * 720

    double angleFrom12 = touchAngle + pi / 2;
    // Normalize to 0..2pi
    if (angleFrom12 < 0) angleFrom12 += 2 * pi;

    final targetMinutesFrom12 = (angleFrom12 / (2 * pi)) * 720;

    // Get current time's minutes from 12
    DateTime currentBase;
    if (_dragMode == _DragMode.bed) {
      currentBase = widget.bedTime;
    } else {
      currentBase = widget.wakeTime;
    }

    final currentMinutesFrom12 =
        (currentBase.hour % 12) * 60 + currentBase.minute;

    // Calculate smallest difference (shortest path)
    var diff = targetMinutesFrom12 - currentMinutesFrom12;
    // Normalize diff to -360..360 (half circle)
    if (diff > 360) diff -= 720;
    if (diff < -360) diff += 720;

    final minutesToAdd = diff.round();

    if (minutesToAdd == 0) return;

    if (_dragMode == _DragMode.bed) {
      final newBedTime = widget.bedTime.add(Duration(minutes: minutesToAdd));
      final duration = widget.wakeTime.difference(newBedTime).inMinutes;
      // Constraint: Minimum 120 minutes (2 hours) sleep for meaningful data
      if (duration >= 120) {
        widget.onBedTimeChanged(newBedTime);
      }
    } else if (_dragMode == _DragMode.wake) {
      final newWakeTime = widget.wakeTime.add(Duration(minutes: minutesToAdd));
      final duration = newWakeTime.difference(widget.bedTime).inMinutes;
      // Constraint: Minimum 120 minutes (2 hours) sleep for meaningful data
      if (duration >= 120) {
        widget.onWakeTimeChanged(newWakeTime);
      }
    }
  }

  double _coordToAngle(Offset coord, Offset center) {
    final offset = coord - center;
    // atan2 gives -pi to pi.
    // We want -pi/2 (top) to match logic?
    // Logic:
    // 12h clock starting at top.
    // atan2(y, x):
    // Right (0) -> 0
    // Down (y+) -> pi/2
    // Left -> pi/-pi
    // Top (y-) -> -pi/2
    // Matches standard unit circle.
    // But our Logic expects "Clock 12" at Top?
    // Let's ensure _dateTimeToAngle matches this coordinate system.
    return atan2(offset.dy, offset.dx);
  }

  // Same logic as Painter
  double _dateTimeToAngle(DateTime dt) {
    double totalMinutes = (dt.hour % 12) * 60.0 + dt.minute;
    // 12 hours = 720 minutes
    // angle = (minutes / 720) * 2pi
    // Rotate -90 degrees (-pi/2) to make 12:00 at top.
    double angle = (totalMinutes / 720.0) * 2 * pi - pi / 2;

    // Normalize to -pi to pi for consistent comparison with atan2
    return _normalizeAngle(angle);
  }

  double _normalizeAngle(double angle) {
    while (angle <= -pi) angle += 2 * pi;
    while (angle > pi) angle -= 2 * pi;
    return angle;
  }

  double _angularDistance(double a, double b) {
    double diff = (a - b).abs();
    if (diff > pi) diff = 2 * pi - diff;
    return diff;
  }
}

enum _DragMode { none, bed, wake }

class MoonTimeDialPainter extends CustomPainter {
  final DateTime bedTime;
  final DateTime wakeTime;
  final Color baseColor;
  final Color activeColor;
  final Color handlerColor;

  MoonTimeDialPainter({
    required this.bedTime,
    required this.wakeTime,
    required this.baseColor,
    required this.activeColor,
    required this.handlerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 8.0;

    // Background Arc (Track)
    final paintTrack = Paint()
      ..color = baseColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth, paintTrack);

    // Active Arc (Sleep Duration)
    // Convert 24h time to angles (0 degrees = 12 AM midnight? Let's say top is 12 PM noon, bottom 12 AM midnight for sleep context?)
    // Actually, traditionally clocks: Top = 12.
    // Let's us standard 12H clock face mapping, but for 24 hours?
    // Sleep usually spans evening to morning. A 24h dial is better.
    // Top = 12:00 (Noon), Bottom = 00:00 (Midnight).
    // Or Bottom = 18:00 (6 PM), Top = 06:00 (6 AM)?
    // Let's stick to standard 12-hour analog clock visual for familiarity, usually AM/PM is context.
    // BUT spec says "Moon Phase Dial".
    // Let's implement a standard 12h clock face for simplicity of interaction first,
    // or a 24h single loop. 24h loop is intuitive for "Duration".
    // Top = 00:00 (Midnight) might be best for sleep.
    // Let's use: Top = 00:00. Right = 06:00. Bottom = 12:00. Left = 18:00.

    // Convert 12h time to angle (for standard analog visual)
    // 12 hours = 360 degrees = 2pi
    // Top = 12:00
    double dateTimeToAngle(DateTime dt) {
      double totalMinutes = (dt.hour % 12) * 60.0 + dt.minute;
      // 12 hours = 720 minutes
      // angle = (minutes / 720) * 2pi
      // Rotate -90 degrees (-pi/2) to make 12:00 at top.
      return (totalMinutes / 720.0) * 2 * pi - pi / 2;
    }

    double startAngle = dateTimeToAngle(bedTime);
    double endAngle = dateTimeToAngle(wakeTime);

    // Calculate sweep angle correctly for cross-midnight/PM-AM logic on 12h face
    // On 12h face, standard arithmetic might result in negative or small sweep if just doing end - start?
    // Wait, visual representation is what matters.
    // BedTime 23:00 (11) -> 330 deg. Wake 07:00 (7) -> 210 deg.
    // If we draw clockwise from 330 to 210, we cross 0.
    // Visual sweep: (210 - 330) = -120 + 360 = 240 degrees. (Correct for 8 hours visually? No.)
    // 8 hours on 12h clock is 8/12 * 360 = 240 degrees? Yes.
    // Because 1 hour = 30 degrees. 8 * 30 = 240.
    // So logic holds.

    double sweepAngle = endAngle - startAngle;

    // Handle wrap-around
    if (sweepAngle < 0) {
      sweepAngle += 2 * pi;
    }

    final paintActive = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      startAngle,
      sweepAngle,
      false,
      paintActive,
    );

    // Draw Clock Markers (12, 3, 6, 9) - Standard Analog Clock
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 4; i++) {
      // i=0 -> 12 (Top) (-90 deg)
      // i=1 -> 3 (Right) (0 deg)
      // i=2 -> 6 (Bottom) (90 deg)
      // i=3 -> 9 (Left) (180 deg)
      final angle = i * (pi / 2) - pi / 2;
      final markerPos = Offset(
        center.dx + (radius - 30) * cos(angle),
        center.dy + (radius - 30) * sin(angle),
      );

      String text;
      switch (i) {
        case 0:
          text = '12';
          break;
        case 1:
          text = '3';
          break;
        case 2:
          text = '6';
          break;
        case 3:
          text = '9';
          break;
        default:
          text = '';
      }

      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        markerPos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Draw Ticks
    final paintTick = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 12; i++) {
      if (i % 3 == 0) continue; // Skip main markers
      final angle = i * (pi / 6) - pi / 2;
      final p1 = Offset(
        center.dx + (radius - 15) * cos(angle),
        center.dy + (radius - 15) * sin(angle),
      );
      final p2 = Offset(
        center.dx + (radius - 25) * cos(angle),
        center.dy + (radius - 25) * sin(angle),
      );
      canvas.drawLine(p1, p2, paintTick);
    }

    drawHandler(
      canvas,
      center,
      radius,
      startAngle,
      Icons.bedtime,
      activeColor,
    ); // Bedtime (Moon)
    drawHandler(
      canvas,
      center,
      radius,
      endAngle,
      Icons.wb_sunny,
      Colors.orangeAccent,
    ); // WakeTime (Sun)
  }

  void drawHandler(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    IconData icon,
    Color color,
  ) {
    final handlerPos = Offset(
      center.dx + (radius - 8) * cos(angle),
      center.dy + (radius - 8) * sin(angle),
    );

    final paintHandler = Paint()..color = color;
    // Increased size for better visual feedback (Radius 14 -> 24)
    canvas.drawCircle(handlerPos, 24, paintHandler);

    // Draw icon inside circle
    final iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Colors.white,
        fontSize: 26, // Increased from 16
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      handlerPos - Offset(iconPainter.width / 2, iconPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant MoonTimeDialPainter oldDelegate) {
    return oldDelegate.bedTime != bedTime || oldDelegate.wakeTime != wakeTime;
  }
}
