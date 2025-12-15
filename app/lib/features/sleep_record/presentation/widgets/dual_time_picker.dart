import 'package:flutter/material.dart';
import 'dart:math' as math;

class DualTimePicker extends StatefulWidget {
  final DateTime sleepTime;
  final DateTime wakeTime;
  final ValueChanged<DateTime>? onSleepTimeChanged;
  final ValueChanged<DateTime>? onWakeTimeChanged;
  final bool isNightMode;
  final String title;
  final Color primaryColor;
  final Color accentColor;

  const DualTimePicker({
    super.key,
    required this.sleepTime,
    required this.wakeTime,
    this.onSleepTimeChanged,
    this.onWakeTimeChanged,
    this.isNightMode = false,
    required this.title,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<DualTimePicker> createState() => _DualTimePickerState();
}

class _DualTimePickerState extends State<DualTimePicker> {
  @override
  Widget build(BuildContext context) {
    final size = 280.0;
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 40;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 시계 컨테이너
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF5F5F5),
            border: Border.all(
              color: widget.primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 시계 배경
              CustomPaint(
                size: Size(size, size),
                painter: ClockPainter(
                  sleepTime: widget.sleepTime,
                  wakeTime: widget.wakeTime,
                  primaryColor: widget.primaryColor,
                  accentColor: widget.accentColor,
                ),
              ),

              // 잠든 시간 핀
              SleepTimePin(
                time: widget.sleepTime,
                onTimeChanged: widget.onSleepTimeChanged,
                color: widget.primaryColor,
                clockCenter: center,
                clockRadius: radius,
                isEnabled: true,
              ),

              // 일어난 시간 핀
              WakeTimePin(
                time: widget.wakeTime,
                onTimeChanged: widget.isNightMode
                    ? null
                    : widget.onWakeTimeChanged,
                color: widget.accentColor,
                clockCenter: center,
                clockRadius: radius,
                isEnabled: !widget.isNightMode,
              ),

              // 중앙 원
              Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 시간 표시
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.primaryColor.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${widget.sleepTime.hour.toString().padLeft(2, '0')}:${widget.sleepTime.minute.toString().padLeft(2, '0')} ~ ${widget.wakeTime.hour.toString().padLeft(2, '0')}:${widget.wakeTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: widget.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime sleepTime;
  final DateTime wakeTime;
  final Color primaryColor;
  final Color accentColor;

  ClockPainter({
    required this.sleepTime,
    required this.wakeTime,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 40;

    // 시간 표시 (12, 3, 6, 9시)
    final hourTextStyle = TextStyle(
      color: primaryColor.withValues(alpha: 0.8),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final mainHours = [12, 3, 6, 9];
    for (int hour in mainHours) {
      final angle = (hour * 30 - 90) * math.pi / 180;
      final x = center.dx + (radius + 20) * math.cos(angle);
      final y = center.dy + (radius + 20) * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(text: hour.toString(), style: hourTextStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // 작은 점들로 시간 표시
    final hourPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      if (!mainHours.contains(i == 0 ? 12 : i)) {
        final angle = (i * 30 - 90) * math.pi / 180;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        canvas.drawCircle(Offset(x, y), 2, hourPaint);
      }
    }

    // 잠든 시간 구간 표시
    _drawSleepArc(canvas, center, radius);
  }

  void _drawSleepArc(Canvas canvas, Offset center, double radius) {
    // 잠든 시간과 일어난 시간의 각도 계산 (시침 방식)
    final sleepAngle = _timeToHourHandAngle(sleepTime);
    final wakeAngle = _timeToHourHandAngle(wakeTime);

    // 잠든 시간 구간의 각도 차이
    double sweepAngle = wakeAngle - sleepAngle;
    if (sweepAngle < 0) {
      sweepAngle += 2 * math.pi;
    }

    // 잠든 시간 구간을 어두운 색으로 표시
    final sleepPaint = Paint()
      ..color = const Color(0xFF1A1F3A).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      sleepAngle,
      sweepAngle,
      true,
      sleepPaint,
    );
  }

  double _timeToHourHandAngle(DateTime time) {
    // 시침 위치 계산 (시침은 시간당 30도, 분당 0.5도 이동)
    final hour = time.hour == 0 ? 12 : time.hour % 12;
    final minute = time.minute;

    final hourAngle = hour * 30; // 시간당 30도
    final minuteAngle = minute * 0.5; // 분당 0.5도
    final totalAngle = hourAngle + minuteAngle;

    // 12시 방향이 0도가 되도록 변환
    return (totalAngle * math.pi / 180) + math.pi / 2;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SleepTimePin extends StatefulWidget {
  final DateTime time;
  final ValueChanged<DateTime>? onTimeChanged;
  final Color color;
  final Offset clockCenter;
  final double clockRadius;
  final bool isEnabled;

  const SleepTimePin({
    super.key,
    required this.time,
    this.onTimeChanged,
    required this.color,
    required this.clockCenter,
    required this.clockRadius,
    this.isEnabled = true,
  });

  @override
  State<SleepTimePin> createState() => _SleepTimePinState();
}

class _SleepTimePinState extends State<SleepTimePin> {
  late Offset _position;
  static const int _minuteStep = 5;

  @override
  void initState() {
    super.initState();
    _updatePosition();
  }

  @override
  void didUpdateWidget(SleepTimePin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.time != oldWidget.time) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    final angle = _timeToHourHandAngle(widget.time);
    final x = widget.clockCenter.dx + widget.clockRadius * math.cos(angle);
    final y = widget.clockCenter.dy + widget.clockRadius * math.sin(angle);
    _position = Offset(x, y);
  }

  double _timeToHourHandAngle(DateTime time) {
    // 시침 위치 계산 (시침은 시간당 30도, 분당 0.5도 이동)
    final hour = time.hour == 0 ? 12 : time.hour % 12;
    final minute = time.minute;

    final hourAngle = hour * 30; // 시간당 30도
    final minuteAngle = minute * 0.5; // 분당 0.5도
    final totalAngle = hourAngle + minuteAngle;

    // 12시 방향이 0도가 되도록 변환
    return (totalAngle * math.pi / 180) + math.pi / 2;
  }

  DateTime _hourHandAngleToTime(double angle) {
    // 각도를 도 단위로 변환
    final angleInDegrees = (angle - math.pi / 2) * 180 / math.pi;
    final normalizedAngle = angleInDegrees < 0
        ? angleInDegrees + 360
        : angleInDegrees;

    // 시침 위치에서 시간과 분 계산
    final hour = (normalizedAngle / 30).floor() % 12;
    final minute = _snapMinuteToStep(((normalizedAngle % 30) * 2).round());

    final displayHour = hour == 0 ? 12 : hour;

    return DateTime(
      widget.time.year,
      widget.time.month,
      widget.time.day,
      displayHour,
      minute,
    );
  }

  int _snapMinuteToStep(int minute) {
    final snapped = (minute / _minuteStep).round() * _minuteStep;
    // Allow DateTime normalization for 60 -> next hour, but keep values stable.
    return snapped;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || widget.onTimeChanged == null) return;

    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - widget.clockCenter.dx;
    final dy = touchPosition.dy - widget.clockCenter.dy;

    // 시계 중심에서 터치 위치로의 각도 계산
    final angle = math.atan2(dy, dx);

    // 시침 각도로 변환 (12시 방향이 0도가 되도록)
    final hourHandAngle = angle + math.pi / 2;
    final normalizedAngle = hourHandAngle < 0
        ? hourHandAngle + 2 * math.pi
        : hourHandAngle;

    final newTime = _hourHandAngleToTime(normalizedAngle);

    // 5분 단위 스냅: 핀 위치도 스냅된 시간 기준으로 맞춤
    _updatePinPosition(_timeToHourHandAngle(newTime));

    if (newTime != widget.time) {
      widget.onTimeChanged!(newTime);
    }
  }

  void _updatePinPosition(double angle) {
    // 원의 둘레에 핀 배치 (터치 위치와 정확히 일치)
    final x = widget.clockCenter.dx + widget.clockRadius * math.cos(angle);
    final y = widget.clockCenter.dy + widget.clockRadius * math.sin(angle);
    setState(() {
      _position = Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx - 20,
      top: _position.dy - 20,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.bedtime, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class WakeTimePin extends StatefulWidget {
  final DateTime time;
  final ValueChanged<DateTime>? onTimeChanged;
  final Color color;
  final Offset clockCenter;
  final double clockRadius;
  final bool isEnabled;

  const WakeTimePin({
    super.key,
    required this.time,
    this.onTimeChanged,
    required this.color,
    required this.clockCenter,
    required this.clockRadius,
    this.isEnabled = true,
  });

  @override
  State<WakeTimePin> createState() => _WakeTimePinState();
}

class _WakeTimePinState extends State<WakeTimePin> {
  late Offset _position;
  static const int _minuteStep = 5;

  @override
  void initState() {
    super.initState();
    _updatePosition();
  }

  @override
  void didUpdateWidget(WakeTimePin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.time != oldWidget.time) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    final angle = _timeToHourHandAngle(widget.time);
    final x = widget.clockCenter.dx + widget.clockRadius * math.cos(angle);
    final y = widget.clockCenter.dy + widget.clockRadius * math.sin(angle);
    _position = Offset(x, y);
  }

  double _timeToHourHandAngle(DateTime time) {
    // 시침 위치 계산 (시침은 시간당 30도, 분당 0.5도 이동)
    final hour = time.hour == 0 ? 12 : time.hour % 12;
    final minute = time.minute;

    final hourAngle = hour * 30; // 시간당 30도
    final minuteAngle = minute * 0.5; // 분당 0.5도
    final totalAngle = hourAngle + minuteAngle;

    // 12시 방향이 0도가 되도록 변환
    return (totalAngle * math.pi / 180) + math.pi / 2;
  }

  DateTime _hourHandAngleToTime(double angle) {
    // 각도를 도 단위로 변환
    final angleInDegrees = (angle - math.pi / 2) * 180 / math.pi;
    final normalizedAngle = angleInDegrees < 0
        ? angleInDegrees + 360
        : angleInDegrees;

    // 시침 위치에서 시간과 분 계산
    final hour = (normalizedAngle / 30).floor() % 12;
    final minute = _snapMinuteToStep(((normalizedAngle % 30) * 2).round());

    final displayHour = hour == 0 ? 12 : hour;

    return DateTime(
      widget.time.year,
      widget.time.month,
      widget.time.day,
      displayHour,
      minute,
    );
  }

  int _snapMinuteToStep(int minute) {
    final snapped = (minute / _minuteStep).round() * _minuteStep;
    return snapped;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || widget.onTimeChanged == null) return;

    final touchPosition = details.localPosition;
    final dx = touchPosition.dx - widget.clockCenter.dx;
    final dy = touchPosition.dy - widget.clockCenter.dy;

    // 시계 중심에서 터치 위치로의 각도 계산
    final angle = math.atan2(dy, dx);

    // 시침 각도로 변환 (12시 방향이 0도가 되도록)
    final hourHandAngle = angle + math.pi / 2;
    final normalizedAngle = hourHandAngle < 0
        ? hourHandAngle + 2 * math.pi
        : hourHandAngle;

    final newTime = _hourHandAngleToTime(normalizedAngle);

    // 5분 단위 스냅: 핀 위치도 스냅된 시간 기준으로 맞춤
    _updatePinPosition(_timeToHourHandAngle(newTime));

    if (newTime != widget.time) {
      widget.onTimeChanged!(newTime);
    }
  }

  void _updatePinPosition(double angle) {
    // 원의 둘레에 핀 배치 (터치 위치와 정확히 일치)
    final x = widget.clockCenter.dx + widget.clockRadius * math.cos(angle);
    final y = widget.clockCenter.dy + widget.clockRadius * math.sin(angle);
    setState(() {
      _position = Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx - 20,
      top: _position.dy - 20,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.wb_sunny, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
