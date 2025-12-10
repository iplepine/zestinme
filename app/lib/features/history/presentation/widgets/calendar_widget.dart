import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import '../../../../core/models/emotion_record.dart';
import '../providers/history_provider.dart';

class CalendarWidget extends ConsumerWidget {
  final List<EmotionRecord> records;

  const CalendarWidget({super.key, required this.records});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDay = ref.watch(historyDateProvider);

    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: AppTheme.textTheme.titleMedium!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(color: Colors.white70),
        weekendTextStyle: const TextStyle(color: Colors.white60),
        outsideTextStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      onPageChanged: (focusedDay) {
        ref.read(historyDateProvider.notifier).updateDate(focusedDay);
      },
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(historyDateProvider.notifier).updateDate(selectedDay);
      },
      selectedDayPredicate: (day) {
        return isSameDay(focusedDay, day);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          // Find record for this day
          final dayRecord = _getRecordForDay(date);
          if (dayRecord == null) return null;

          return Positioned(
            bottom: 1,
            child: _buildEmotionMarker(context, dayRecord),
          );
        },
      ),
    );
  }

  EmotionRecord? _getRecordForDay(DateTime date) {
    // Return the latest record for the day (or most intense based on logic)
    // Here we just take the first one found for simplicity of MVP
    try {
      return records.firstWhere((r) => isSameDay(r.timestamp, date));
    } catch (e) {
      return null;
    }
  }

  Widget _buildEmotionMarker(BuildContext context, EmotionRecord record) {
    // Determine color based on valence (simplified logic for now)
    // High Valence (Pos) -> Green/Yellow, Low Valence (Neg) -> Blue/Red
    Color markerColor = Colors.grey;
    if ((record.valence ?? 0) > 0) {
      markerColor = AppTheme.secondaryColor; // Joyful
    } else {
      markerColor = Colors.blueAccent; // Sad/Calm
    }

    // In future, use the specific emotion icon/seed
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: markerColor, shape: BoxShape.circle),
    );
  }
}
