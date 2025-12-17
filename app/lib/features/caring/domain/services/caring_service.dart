import 'dart:math';
import '../../../../core/constants/coaching_questions.dart';
import '../../../../core/models/emotion_record.dart';

class CaringService {
  /// Check if a record is pending "Caring" (Nurturing)
  static bool isRecordPendingCaring(EmotionRecord record) {
    if (record.isCared) return false;

    final now = DateTime.now();
    final diff = now.difference(record.timestamp);

    // 1. Incubation Time (4 hours)
    if (diff.inHours >= 4) return true;

    // 2. Nightly Wrap-up (22:00 ~ 04:00)
    final hour = now.hour;
    final isNightTime = hour >= 22 || hour < 4;

    if (isNightTime) {
      // If it's night time, allow cleaning up records from last 24h
      if (diff.inHours < 24) return true;
    }

    return false;
  }

  /// Determines the maximum coaching depth (0, 1, 2) based on context.
  /// 0: Stage 1 (Mirroring/Grounding)
  /// 1: Stage 2 (Expansion)
  /// 2: Stage 3 (Core Needs)
  static int calculateCoachingDepth(EmotionRecord record) {
    // 1. Time Constraint: Late Night (> 22:00) -> Shallow (Stage 0) for sleep
    final now = DateTime.now();
    if (now.hour >= 22 || now.hour < 5) {
      return 0;
    }

    // 2. Energy Constraint: High Arousal (> 7) -> Shallow for grounding
    if ((record.arousal ?? 0) > 7) {
      return 0; // Too intense for deep analysis
    }

    // 3. Variable Reward (Randomness)
    final random = Random().nextInt(10); // 0-9
    // 20% Chance: Quick Session (Lucky!)
    if (random < 2) {
      return 0;
    }
    // 20% Chance: Deep Dive (Bonus Insight!)
    else if (random >= 8) {
      return 2;
    }

    // Default: Moderate Depth (Stage 2)
    return 1;
  }

  /// Selects a question based on depth and formats it with context.
  static String selectCoachingQuestion(
    EmotionRecord record,
    int stage, {
    String? fallbackContext,
  }) {
    // 1. Get Template
    final key = record.emotionLabel ?? 'Anxious'; // Default fallback
    String template = CoachingQuestions.getQuestion(key, stage);

    // 2. Inject Context (The "Mirror" Effect)
    // Use detailedNote if available, otherwise use provided fallback or emotion label
    final context =
        (record.detailedNote != null && record.detailedNote!.isNotEmpty)
        ? record.detailedNote!
        : (fallbackContext ?? record.emotionLabel ?? '이 기분');

    return template.replaceAll('{context}', context);
  }
}
