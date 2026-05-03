import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
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
          final dayRecord = _getRecordForDay(date);
          if (dayRecord == null) return null;

          return Positioned(
            bottom: 1,
            child: _buildConditionMarker(context, dayRecord),
          );
        },
      ),
    );
  }

  EmotionRecord? _getRecordForDay(DateTime date) {
    final matches = records.where((r) => isSameDay(r.timestamp, date)).toList();
    if (matches.isEmpty) return null;

    matches.sort((a, b) {
      final aSleep = _isSleepEntry(a);
      final bSleep = _isSleepEntry(b);
      if (aSleep != bSleep) return aSleep ? 1 : -1;
      return _conditionScore(b).compareTo(_conditionScore(a));
    });

    return matches.first;
  }

  Widget _buildConditionMarker(BuildContext context, EmotionRecord record) {
    final score = _conditionScore(record);
    final colorScheme = Theme.of(context).colorScheme;
    final markerColor = _scoreColor(score, colorScheme);
    final scoreLabel = score == 0 ? '--' : score.toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: markerColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        scoreLabel,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  bool _isSleepEntry(EmotionRecord record) {
    final label = record.emotionLabel?.toLowerCase() ?? '';
    return label.startsWith('sleep');
  }

  double _conditionScore(EmotionRecord record) {
    final score = record.intensity?.toDouble() ?? 0.0;
    if (score <= 0) return 0.0;
    return score * 10;
  }

  Color _scoreColor(double score, ColorScheme colorScheme) {
    if (score >= 80) return colorScheme.secondary;
    if (score >= 65) return colorScheme.primary;
    if (score >= 45) return Colors.amber;
    return Colors.deepOrangeAccent;
  }
}
