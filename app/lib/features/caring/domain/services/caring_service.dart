import '../../../../core/constants/coaching_questions.dart';
import '../../../../core/models/emotion_record.dart';

class CaringService {
  /// Check if a record is pending "Caring" (Nurturing)
  ///
  /// Criteria:
  /// 1. Not yet cared (`caredAt == null`)
  /// 2. Satisfies ONE of:
  ///    - Created > 4 hours ago (Incubation)
  ///    - Nightly Wrap-up: It's night time (22:00 ~ 04:00) AND record is from today
  static bool isRecordPendingCaring(EmotionRecord record) {
    if (record.isCared) return false;

    final now = DateTime.now();
    final diff = now.difference(record.timestamp);

    // 1. Incubation Time (4 hours)
    if (diff.inHours >= 4) return true;

    // 2. Nightly Wrap-up (22:00 ~ 04:00)
    // If it's night time, allow cleaning up all of today's records
    final hour = now.hour;
    final isNightTime = hour >= 22 || hour < 4;

    if (isNightTime) {
      // Check if record is from "today" (considering night owl logic if needed,
      // but for simplicity, let's say within last 24h is close enough context)
      // Actually strictly "Today's record" might be better.
      // If past midnight (hour < 4), compare with yesterday?
      // Let's keep it simple: if it's night time, any recent uncared record is fair game.
      if (diff.inHours < 24) return true;
    }

    return false;
  }

  /// Select a Coaching Question for the record
  ///
  /// Strategy:
  /// - Use Emotion Label/Tag to map to Question Category
  /// - Randomly pick one from the category
  static String selectCoachingQuestion(EmotionRecord record) {
    // 1. Determine Category (Red, Blue, Yellow, Green)
    // This mapping logic should ideally be in a shared domain space or mapped from Emotion Enum
    // For now, we rely on the `CoachingQuestions` constant map if available, or simple keywords.

    // Use the mapped CoachingQuestions based on the emotion label
    if (record.emotionLabel != null && record.emotionLabel!.isNotEmpty) {
      return CoachingQuestions.getQuestionForTag(record.emotionLabel!);
    }

    // Fallback if no label
    return "지금 이 감정이 당신에게 말하고자 하는 것은 무엇인가요?";
  }
}
