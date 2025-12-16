import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zestinme/core/models/emotion_record.dart';
import 'package:zestinme/core/models/sleep_record.dart';
import 'package:zestinme/features/onboarding/data/models/onboarding_data_model.dart';

class LocalDbService {
  late Isar _isar;
  Isar get isar => _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      EmotionRecordSchema,
      OnboardingDataModelSchema,
      SleepRecordSchema,
    ], directory: dir.path);
  }

  // --- Emotion Record ---

  // Create
  Future<void> saveEmotionRecord(EmotionRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.emotionRecords.put(record);
    });
  }

  // Read
  Future<List<EmotionRecord>> getAllEmotionRecords() async {
    return await _isar.emotionRecords.where().sortByTimestampDesc().findAll();
  }

  Future<EmotionRecord?> getEmotionRecord(int id) async {
    return await _isar.emotionRecords.get(id);
  }

  // Delete
  Future<void> deleteEmotionRecord(int id) async {
    await _isar.writeTxn(() async {
      await _isar.emotionRecords.delete(id);
    });
  }

  // Pending Caring Query
  Future<List<EmotionRecord>> getUncaredEmotionRecords() async {
    return await _isar.emotionRecords
        .filter()
        .caredAtIsNull()
        .sortByTimestampDesc()
        .findAll();
  }

  // Range Query for Calibration/History
  Future<List<EmotionRecord>> getEmotionRecordsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _isar.emotionRecords
        .where()
        .filter()
        .timestampBetween(start, end)
        .sortByTimestampDesc()
        .findAll();
  }

  // --- Sleep Record ---

  Future<void> saveSleepRecord(SleepRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.sleepRecords.put(record);
    });
  }

  Future<SleepRecord?> getSleepRecordByDate(DateTime date) async {
    // Basic implementation: find record with same YMD
    // Ideally we structure 'date' field to be midnight of that day for easier query
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await _isar.sleepRecords
        .filter()
        .dateGreaterThan(startOfDay, include: true)
        .and()
        .dateLessThan(endOfDay)
        .findFirst();
  }

  Future<List<SleepRecord>> getSleepRecordsByRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _isar.sleepRecords
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
  }

  Future<void> deleteSleepRecord(int id) async {
    await _isar.writeTxn(() async {
      await _isar.sleepRecords.delete(id);
    });
  }
}
