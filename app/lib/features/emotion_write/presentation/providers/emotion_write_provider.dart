import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/core/models/emotion_record.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:get_it/get_it.dart';

part 'emotion_write_provider.g.dart';

@riverpod
class EmotionWrite extends _$EmotionWrite {
  @override
  EmotionRecord build() {
    return EmotionRecord()
      ..timestamp = DateTime.now()
      ..activities = []
      ..people = []
      ..bodySensations = [];
  }

  void updateValenceArousal(double valence, double arousal) {
    state = state
      ..valence = valence
      ..arousal = arousal;
    // Logic to update emotionLabel based on coordinates would go here
    // For MVP, we might just let user select from chips, but spec says chips update based on coords
    // We will implement a helper to get candidates later.
  }

  void setEmotionLabel(String label) {
    state = state..emotionLabel = label;
  }

  void toggleActivity(String activity) {
    final current = state.activities ?? [];
    if (current.contains(activity)) {
      state = state..activities = current.where((e) => e != activity).toList();
    } else {
      state = state..activities = [...current, activity];
    }
  }

  void togglePerson(String person) {
    final current = state.people ?? [];
    if (current.contains(person)) {
      state = state..people = current.where((e) => e != person).toList();
    } else {
      state = state..people = [...current, person];
    }
  }

  void setLocation(String location) {
    state = state..location = location;
  }

  void toggleBodySensation(String sensation) {
    final current = state.bodySensations ?? [];
    if (current.contains(sensation)) {
      state = state
        ..bodySensations = current.where((e) => e != sensation).toList();
    } else {
      state = state..bodySensations = [...current, sensation];
    }
  }

  void setAutomaticThought(String thought) {
    state = state..automaticThought = thought;
  }

  void setActionTaken(String action) {
    state = state..actionTaken = action;
  }

  Future<void> saveRecord() async {
    final dbService = GetIt.I<LocalDbService>();
    await dbService.saveEmotionRecord(state);
  }
}
