import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class DraggableTimePin extends StatefulWidget {
  final DateTime time;
  final ValueChanged<DateTime>? onTimeChanged;
  final Color color;
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isEnabled;
  final double clockRadius;
  final Offset clockCenter;

  const DraggableTimePin({
    super.key,
    required this.time,
    this.onTimeChanged,
    required this.color,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isEnabled = true,
    required this.clockRadius,
    required this.clockCenter,
  });

  @override
  State<DraggableTimePin> createState() => _DraggableTimePinState();
}

class _DraggableTimePinState extends State<DraggableTimePin>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isDragging = false;
  Offset _position = Offset.zero;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150), // 더 빠른 반응
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200), // 더 부드러운 펄스
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _updatePosition();

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DraggableTimePin oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.time != oldWidget.time) {
      _updatePosition();
    }

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _updatePosition() {
    _updatePositionForTime(widget.time);
  }

  void _updatePositionForTime(DateTime time) {
    // 12시간 형식으로 변환
    final hour = time.hour == 0 ? 12 : time.hour % 12;
    final minute = time.minute;
    final totalMinutes = hour * 60 + minute;

    // 12시 방향이 0도가 되도록 각도 계산
    final angle = (totalMinutes / (12 * 60)) * 2 * math.pi;

    // cos/sin은 3시 방향이 0도이므로 -π/2 오프셋 적용
    final circleAngle = angle - math.pi / 2;
    final x =
        widget.clockCenter.dx + widget.clockRadius * math.cos(circleAngle);
    final y =
        widget.clockCenter.dy + widget.clockRadius * math.sin(circleAngle);

    setState(() {
      _position = Offset(x, y);
    });
  }

  void _updatePositionOnCircle(double angle) {
    // 각도를 0~2π 범위로 정규화
    double normalizedAngle = angle % (2 * math.pi);
    if (normalizedAngle < 0) {
      normalizedAngle += 2 * math.pi;
    }

    // 원의 둘레에 정확히 맞춰서 핀 위치 계산
    // 12시 방향이 0도이므로 -π/2 오프셋 적용
    final circleAngle = normalizedAngle - math.pi / 2;
    final x =
        widget.clockCenter.dx + widget.clockRadius * math.cos(circleAngle);
    final y =
        widget.clockCenter.dy + widget.clockRadius * math.sin(circleAngle);

    setState(() {
      _position = Offset(x, y);
    });
  }

  double _getAngleFromTouchPosition(Offset touchPosition) {
    // 시계 중심과 터치 위치를 기준으로 각도 계산
    final dx = touchPosition.dx - widget.clockCenter.dx;
    final dy = touchPosition.dy - widget.clockCenter.dy;

    // 각도 계산 (atan2는 -π ~ π 범위를 반환)
    // atan2는 3시 방향이 0도, 12시 방향이 -π/2
    // 12시 방향을 0도로 만들기 위해 π/2를 더함
    final angle = math.atan2(dy, dx) + math.pi / 2;

    // 각도를 0~2π 범위로 정규화
    return angle < 0 ? angle + 2 * math.pi : angle;
  }

  DateTime _getTimeFromAngle(double angle) {
    // 각도를 0~2π 범위로 정규화
    double normalizedAngle = angle % (2 * math.pi);
    if (normalizedAngle < 0) {
      normalizedAngle += 2 * math.pi;
    }

    // 각도를 분으로 변환 (12시간 = 720분)
    // 12시 방향이 0도로 정규화되어 있음
    final totalMinutes = (normalizedAngle / (2 * math.pi)) * 720;

    // 시간과 분 계산
    final hour = (totalMinutes / 60).floor() % 12;
    final minute = (totalMinutes % 60).round();

    // 1분 단위로 반올림 (더 부드러운 드래그를 위해)
    final roundedMinute = minute.round() % 60;

    // 시간이 0이면 12로 변환 (12시간 형식)
    final displayHour = hour == 0 ? 12 : hour;

    return DateTime(
      widget.time.year,
      widget.time.month,
      widget.time.day,
      displayHour,
      roundedMinute,
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.isEnabled || widget.onTimeChanged == null) return;

    setState(() {
      _isDragging = true;
    });

    _scaleController.forward();
    HapticFeedback.lightImpact();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || widget.onTimeChanged == null || !_isDragging)
      return;

    // 현재 터치 위치를 시계 중심 기준으로 변환
    final touchPosition = details.localPosition;

    // 시계 중심과 터치 위치를 기준으로 각도 계산
    final angle = _getAngleFromTouchPosition(touchPosition);
    final newTime = _getTimeFromAngle(angle);

    // 시간이 실제로 변경되었을 때만 콜백 호출
    if (newTime != widget.time) {
      widget.onTimeChanged!(newTime);
    }

    // 핀 위치를 원의 둘레에 맞춰서 업데이트
    _updatePositionOnCircle(angle);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isEnabled) return;

    setState(() {
      _isDragging = false;
    });

    _scaleController.reverse();
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx - 40, // 아이콘 중앙이 침의 끝과 일치하도록 오프셋 조정 (80px 아이콘의 절반)
      top: _position.dy - 40,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
        builder: (context, child) {
          final scale = _isDragging ? _scaleAnimation.value : 1.0;
          final pulse = widget.isActive ? _pulseAnimation.value : 1.0;

          return Transform.scale(
            scale: scale * pulse,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 80, // 터치 영역 확대
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(
                    alpha: 0.1,
                  ), // 반투명 배경으로 터치 영역 표시
                  border: Border.all(color: widget.color, width: 3),
                ),
                child: Center(
                  child: Container(
                    width: 50, // 실제 아이콘 크기
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                        if (widget.isActive)
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.3),
                            blurRadius: 16,
                            spreadRadius: 6,
                            offset: const Offset(0, 0),
                          ),
                      ],
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
