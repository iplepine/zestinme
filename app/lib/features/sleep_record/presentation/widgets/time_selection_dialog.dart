import 'package:flutter/material.dart';

// 수면 기록용 색상 팔레트
class SleepColors {
  static const primary = Color(0xFF6366F1); // 인디고
  static const primaryForeground = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFE0E7FF); // 인디고 100
  static const secondaryForeground = Color(0xFF1E1B4B);
  static const accent = Color(0xFF8B5CF6); // 바이올렛
  static const accentForeground = Color(0xFFFFFFFF);
  static const muted = Color(0xFFF8FAFC);
  static const mutedForeground = Color(0xFF64748B);
  static const background = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF0F172A);
  static const border = Color(0xFFE2E8F0);
}

// 커스텀 시간 선택 다이얼로그
class TimeSelectionDialog extends StatefulWidget {
  final DateTime currentTime;
  final Function(DateTime) onTimeSelected;

  const TimeSelectionDialog({
    super.key,
    required this.currentTime,
    required this.onTimeSelected,
  });

  @override
  State<TimeSelectionDialog> createState() => _TimeSelectionDialogState();
}

class _TimeSelectionDialogState extends State<TimeSelectionDialog> {
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.currentTime.hour;
    _selectedMinute = _roundToNearestFive(widget.currentTime.minute);
  }

  // 분을 5분 단위로 반올림하는 함수
  int _roundToNearestFive(int minute) {
    return ((minute + 2) ~/ 5) * 5;
  }

  void _setQuickTime(String timeLabel, int hour, int minute) {
    setState(() {
      _selectedHour = hour;
      _selectedMinute = _roundToNearestFive(minute);
    });
  }

  void _confirmSelection() {
    final newTime = DateTime(
      widget.currentTime.year,
      widget.currentTime.month,
      widget.currentTime.day,
      _selectedHour,
      _selectedMinute,
    );
    widget.onTimeSelected(newTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: SleepColors.primary.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: SleepColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '시간 선택',
                    style: TextStyle(
                      color: SleepColors.foreground,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 빠른 선택 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: QuickTimeButton(
                          label: '지금',
                          onTap: () => _setQuickTime(
                            '지금',
                            DateTime.now().hour,
                            DateTime.now().minute,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: QuickTimeButton(
                          label: '아침',
                          onTap: () => _setQuickTime('아침', 8, 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: QuickTimeButton(
                          label: '점심',
                          onTap: () => _setQuickTime('점심', 12, 0),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: QuickTimeButton(
                          label: '저녁',
                          onTap: () => _setQuickTime('저녁', 18, 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 시간/분 조절
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '시간',
                                style: TextStyle(
                                  color: SleepColors.foreground,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedHour =
                                            (_selectedHour - 1 + 24) % 24;
                                      });
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: SleepColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: SleepColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedHour >= 12 ? (_selectedHour - 12).toString().padLeft(2, '0') : _selectedHour.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: SleepColors.foreground,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedHour =
                                            (_selectedHour + 1) % 24;
                                      });
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: SleepColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: SleepColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '분',
                                style: TextStyle(
                                  color: SleepColors.foreground,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedMinute =
                                            (_selectedMinute - 5 + 60) % 60;
                                      });
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: SleepColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: SleepColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedMinute.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: SleepColors.foreground,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedMinute =
                                            (_selectedMinute + 5) % 60;
                                      });
                                    },
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: SleepColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: SleepColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: SleepColors.foreground,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _confirmSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SleepColors.primary,
                            foregroundColor: SleepColors.primaryForeground,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 빠른 시간 선택 버튼
class QuickTimeButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const QuickTimeButton({super.key, required this.label, required this.onTap});

  @override
  State<QuickTimeButton> createState() => _QuickTimeButtonState();
}

class _QuickTimeButtonState extends State<QuickTimeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _isPressed
              ? SleepColors.primary.withValues(alpha: 0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isPressed ? SleepColors.primary : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _isPressed ? SleepColors.primary : SleepColors.foreground,
            fontSize: 14,
            fontWeight: _isPressed ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
