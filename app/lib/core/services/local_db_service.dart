import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zestinme/core/models/emotion_record.dart';
import 'package:zestinme/features/onboarding/data/models/onboarding_data_model.dart';

class LocalDbService {
  late Isar _isar;
  Isar get isar => _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      EmotionRecordSchema,
      OnboardingDataModelSchema,
    ], directory: dir.path);
  }

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
}
