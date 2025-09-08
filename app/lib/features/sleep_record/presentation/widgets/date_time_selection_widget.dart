import 'package:flutter/material.dart';
import 'time_selection_dialog.dart';

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

class DateTimeSelectionWidget extends StatelessWidget {
  final DateTime selectedDateTime;
  final Function(DateTime)? onDateTimeChanged;

  const DateTimeSelectionWidget({
    super.key,
    required this.selectedDateTime,
    this.onDateTimeChanged,
  });

  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  String _getRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inDays;

    if (difference == 1) return '어제';
    if (difference == 2) return '그제';
    if (difference == -1) return '내일';
    if (difference == -2) return '모레';
    if (difference > 0) return '$difference일 전';
    if (difference < 0) return '${-difference}일 후';
    return '오늘';
  }

  String _getTimeDescription(DateTime dateTime) {
    final hour = dateTime.hour;

    if (hour < 6) return '새벽';
    if (hour < 12) return '오전';
    if (hour < 18) return '오후';
    if (hour < 22) return '저녁';
    return '밤';
  }

  Future<void> _selectDate(BuildContext context) async {
    if (onDateTimeChanged == null) return;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: SleepColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      );
      onDateTimeChanged!(newDateTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (onDateTimeChanged == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimeSelectionDialog(
          currentTime: selectedDateTime,
          onTimeSelected: onDateTimeChanged!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 날짜
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '날짜',
                style: TextStyle(
                  color: SleepColors.mutedForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onDateTimeChanged != null
                    ? () => _selectDate(context)
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: onDateTimeChanged != null
                        ? SleepColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${selectedDateTime.year}.${selectedDateTime.month.toString().padLeft(2, '0')}.${selectedDateTime.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: SleepColors.foreground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.calendar_today,
                        color: SleepColors.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isToday(selectedDateTime)
                    ? '오늘'
                    : _getRelativeDate(selectedDateTime),
                style: TextStyle(
                  color: SleepColors.mutedForeground,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // 시간
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '시간',
                style: TextStyle(
                  color: SleepColors.mutedForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onDateTimeChanged != null
                    ? () => _selectTime(context)
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: onDateTimeChanged != null
                        ? SleepColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedDateTime.hour >= 12
                            ? '오후 ${(selectedDateTime.hour - 12).toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}'
                            : '오전 ${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: SleepColors.foreground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        color: SleepColors.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getTimeDescription(selectedDateTime),
                style: TextStyle(
                  color: SleepColors.mutedForeground,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
