import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'time_selection_dialog.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  final DateTime selectedDateTime;
  final Function(DateTime) onDateTimeChanged;

  const DateTimeSelectionWidget({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
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
            ).colorScheme.copyWith(primary: AppColors.primary),
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
      onDateTimeChanged(newDateTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimeSelectionDialog(
          currentTime: selectedDateTime,
          onTimeSelected: onDateTimeChanged,
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
                  color: AppColors.mutedForeground,
                  fontSize: 12,
                  fontWeight: AppColors.fontWeightMedium,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${selectedDateTime.year}.${selectedDateTime.month.toString().padLeft(2, '0')}.${selectedDateTime.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: AppColors.foreground,
                          fontWeight: AppColors.fontWeightMedium,
                        ),
                      ),
                      const Spacer(),
                      const Text('🗓️', style: TextStyle(fontSize: 16)),
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
                  color: AppColors.mutedForeground,
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
                  color: AppColors.mutedForeground,
                  fontSize: 12,
                  fontWeight: AppColors.fontWeightMedium,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedDateTime.hour >= 12
                            ? '오후 ${(selectedDateTime.hour - 12).toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}'
                            : '오전 ${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: AppColors.foreground,
                          fontWeight: AppColors.fontWeightMedium,
                        ),
                      ),
                      const Spacer(),
                      const Text('🕒', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getTimeDescription(selectedDateTime),
                style: TextStyle(
                  color: AppColors.mutedForeground,
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
