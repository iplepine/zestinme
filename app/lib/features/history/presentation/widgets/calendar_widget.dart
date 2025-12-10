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

    final colorScheme = Theme.of(context).colorScheme;

    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: AppTheme.textTheme.titleMedium!.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.onSurface),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurface,
        ),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: colorScheme.onSurface),
        weekendTextStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        outsideTextStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        todayDecoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: colorScheme.primary,
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
    // Determine color based on valence
    // High Valence (Pos) -> Secondary (Lime/Green)
    // Low Valence (Neg) -> Tertiary/Blue (Use Primary for now or defined color)
    final colorScheme = Theme.of(context).colorScheme;
    Color markerColor;
    if ((record.valence ?? 0) > 0) {
      markerColor = colorScheme.secondary; // Joyful (Lime)
    } else {
      markerColor = Colors.blueAccent; // Sad/Calm
    }

    // Seed/Sprout Icon acting as marker
    return Icon(
      Icons.grass, // Sprout icon representing a planted memory
      size: 8,
      color: markerColor,
    );
  }
}
