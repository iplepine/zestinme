import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/emotion_record.dart';
import '../../../../core/services/local_db_service.dart';
import 'package:get_it/get_it.dart';

part 'history_provider.g.dart';

/// Manages the currently focused date/month in the History Calendar
@riverpod
class HistoryDate extends _$HistoryDate {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void updateDate(DateTime date) {
    state = date;
  }
}

/// Fetches Emotion Records for the month of the currently selected date
@riverpod
Future<List<EmotionRecord>> historyRecords(HistoryRecordsRef ref) async {
  // Only rebuild if the month changes
  final monthDate = ref.watch(
    historyDateProvider.select((date) => DateTime(date.year, date.month)),
  );
  final db = GetIt.I<LocalDbService>();

  // Calculate start and end of the month
  final startOfMonth = DateTime(monthDate.year, monthDate.month, 1);
  final endOfMonth = DateTime(
    monthDate.year,
    monthDate.month + 1,
    0,
    23,
    59,
    59,
  );

  return await db.getEmotionRecordsByDateRange(startOfMonth, endOfMonth);
}
