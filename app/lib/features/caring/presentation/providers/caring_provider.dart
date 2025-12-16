import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/models/emotion_record.dart';
import '../../../../core/services/local_db_service.dart';

// Use the same LocalDbService as sleep for now (it's generic enough or we can make a dedicated one)
// But wait, LocalDbService in sleep might be specific. Let's check.
// If it's generic, great. If not, we might need a general `RecordRepository`.
// For MVP, let's assume we can access Isar via a provider or service.

final caringProvider = StateNotifierProvider<CaringNotifier, AsyncValue<void>>((
  ref,
) {
  return CaringNotifier();
});

class CaringNotifier extends StateNotifier<AsyncValue<void>> {
  CaringNotifier() : super(const AsyncValue.data(null));

  Future<void> completeCaring({
    required EmotionRecord record,
    required String question,
    required String answer,
    required List<String> valueTags,
  }) async {
    state = const AsyncValue.loading();
    try {
      final db = GetIt.I<LocalDbService>();

      // Create updated record (using copyWith-like logic, but EmotionRecord is mutable in Isar usually?
      // No, Isar objects are just objects. We need to update fields and put it back.)

      // Update fields
      record.caredAt = DateTime.now();
      record.coachingQuestionId = question; // Storing the text as ID for now
      record.coachingAnswer = answer;
      record.valueTags = valueTags;
      // record.status = EmotionRecordStatus.analyzed; // If we used status enum

      // Save to DB
      await db.saveEmotionRecord(record);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
