import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularTimePicker extends StatefulWidget {
  final DateTime selectedTime;
  final ValueChanged<DateTime>? onTimeChanged;
  final bool isEnabled;
  final String title;
  final IconData icon;
  final Color primaryColor;
  final Color accentColor;

  const CircularTimePicker({
    super.key,
    required this.selectedTime,
    this.onTimeChanged,
    this.isEnabled = true,
    required this.title,
    required this.icon,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<CircularTimePicker> createState() => _CircularTimePickerState();
}

class _CircularTimePickerState extends State<CircularTimePicker>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getAngleFromTime(DateTime time) {
    final hour = time.hour % 12;
    final minute = time.minute;
    final totalMinutes = hour * 60 + minute;
    return (totalMinutes / (12 * 60)) * 2 * math.pi - math.pi / 2;
  }

  DateTime _getTimeFromAngle(double angle) {
    final normalizedAngle = (angle + math.pi / 2) % (2 * math.pi);
    final totalMinutes = (normalizedAngle / (2 * math.pi)) * (12 * 60);
    final hour = (totalMinutes / 60).floor() % 12;
    final minute = (totalMinutes % 60).round();
    return DateTime(
      widget.selectedTime.year,
      widget.selectedTime.month,
      widget.selectedTime.day,
      hour,
      minute,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || widget.onTimeChanged == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final center = renderBox.size.center(Offset.zero);
    final localPosition = details.localPosition - center;

    final angle = math.atan2(localPosition.dy, localPosition.dx);
    final newTime = _getTimeFromAngle(angle);

    widget.onTimeChanged!(newTime);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = 200.0;
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 20;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.primaryColor.withValues(alpha: 0.1),
                  widget.accentColor.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: widget.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // 시계 배경
                CustomPaint(
                  size: Size(size, size),
                  painter: ClockBackgroundPainter(
                    primaryColor: widget.primaryColor,
                    accentColor: widget.accentColor,
                    isEnabled: widget.isEnabled,
                  ),
                ),

                // 시간 표시
                Positioned.fill(
                  child: CustomPaint(
                    painter: TimeHandPainter(
                      time: widget.selectedTime,
                      primaryColor: widget.primaryColor,
                      isDragging: _isDragging,
                    ),
                  ),
                ),

                // 중앙 원
                Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // 터치 영역
                if (widget.isEnabled && widget.onTimeChanged != null)
                  Positioned.fill(
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isDragging
                              ? widget.primaryColor.withValues(alpha: 0.1)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClockBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool isEnabled;

  ClockBackgroundPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.isEnabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // 시간 표시 (12, 3, 6, 9시)
    final hourPaint = Paint()
      ..color = primaryColor.withValues(alpha: isEnabled ? 0.6 : 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final hourTextStyle = TextStyle(
      color: primaryColor.withValues(alpha: isEnabled ? 0.9 : 0.4),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i % 3 == 0) {
        // 주요 시간 표시 (12, 3, 6, 9시)
        final hour = i == 0 ? 12 : i;
        final textPainter = TextPainter(
          text: TextSpan(text: hour.toString(), style: hourTextStyle),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2),
        );
      } else {
        // 작은 점 표시
        canvas.drawCircle(Offset(x, y), 2, hourPaint);
      }
    }

    // 분 표시 (5분 간격)
    final minutePaint = Paint()
      ..color = primaryColor.withValues(alpha: isEnabled ? 0.3 : 0.15)
      ..strokeWidth = 1;

    for (int i = 0; i < 60; i += 5) {
      if (i % 15 != 0) {
        // 15분 간격은 제외 (이미 시간 표시에 포함)
        final angle = (i * 6 - 90) * math.pi / 180;
        final x = center.dx + (radius - 10) * math.cos(angle);
        final y = center.dy + (radius - 10) * math.sin(angle);
        canvas.drawCircle(Offset(x, y), 1, minutePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TimeHandPainter extends CustomPainter {
  final DateTime time;
  final Color primaryColor;
  final bool isDragging;

  TimeHandPainter({
    required this.time,
    required this.primaryColor,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // 시간 계산
    final hour = time.hour % 12;
    final minute = time.minute;
    final totalMinutes = hour * 60 + minute;
    final angle = (totalMinutes / (12 * 60)) * 2 * math.pi - math.pi / 2;

    // 시침 그리기
    final hourHandPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = isDragging ? 6 : 4
      ..strokeCap = StrokeCap.round;

    final hourHandLength = radius * 0.6;
    final hourHandEnd = Offset(
      center.dx + hourHandLength * math.cos(angle),
      center.dy + hourHandLength * math.sin(angle),
    );

    canvas.drawLine(center, hourHandEnd, hourHandPaint);

    // 분침 그리기
    final minuteHandPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.7)
      ..strokeWidth = isDragging ? 4 : 3
      ..strokeCap = StrokeCap.round;

    final minuteHandLength = radius * 0.8;
    final minuteHandEnd = Offset(
      center.dx + minuteHandLength * math.cos(angle),
      center.dy + minuteHandLength * math.sin(angle),
    );

    canvas.drawLine(center, minuteHandEnd, minuteHandPaint);

    // 시간 텍스트 표시
    final timeText =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    final textPainter = TextPainter(
      text: TextSpan(
        text: timeText,
        style: TextStyle(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy + radius + 20),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
