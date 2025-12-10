import 'package:zestinme/l10n/app_localizations.dart';

extension EmotionLocalizationUtils on AppLocalizations {
  String getLocalizedEmotion(String tag) {
    switch (tag) {
      // RED (High Energy, Negative)
      case 'Angry':
        return seeding_mood_angry;
      case 'Anxious':
        return seeding_mood_anxious;
      case 'Resentful':
        return seeding_mood_resentful;
      case 'Overwhelmed':
        return seeding_mood_overwhelmed;
      case 'Jealous':
        return seeding_mood_jealous;
      case 'Annoyed':
        return seeding_mood_annoyed;

      // BLUE (Low Energy, Negative)
      case 'Sad':
        return seeding_mood_sad;
      case 'Disappointed':
        return seeding_mood_disappointed;
      case 'Bored':
        return seeding_mood_bored;
      case 'Lonely':
        return seeding_mood_lonely;
      case 'Guilty':
        return seeding_mood_guilty;
      case 'Envious':
        return seeding_mood_envious;

      // YELLOW (High Energy, Positive)
      case 'Excited':
        return seeding_mood_excited;
      case 'Proud':
        return seeding_mood_proud;
      case 'Inspired':
        return seeding_mood_inspired;
      case 'Enthusiastic':
        return seeding_mood_enthusiastic;
      case 'Curious':
        return seeding_mood_curious;
      case 'Amused':
        return seeding_mood_amused;

      // GREEN (Low Energy, Positive)
      case 'Relaxed':
        return seeding_mood_relaxed;
      case 'Grateful':
        return seeding_mood_grateful;
      case 'Content':
        return seeding_mood_content;
      case 'Serene':
        return seeding_mood_serene;
      case 'Trusting':
        return seeding_mood_trusting;
      case 'Reflective':
        return seeding_mood_reflective;

      // Center
      case 'Neutral':
        return seeding_mood_neutral;

      default:
        // Return original tag if no translation found, or "Untitled" handling
        if (tag == 'Untitled') return '무제'; // Fallback for empty
        return tag;
    }
  }
}
