import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/l10n/app_localizations.dart';
import 'package:zestinme/core/utils/emotion_localization_utils.dart';
import 'package:zestinme/core/models/emotion_record.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/core/widgets/zest_glass_card.dart';

class HistoryListItem extends StatelessWidget {
  final EmotionRecord record;
  final VoidCallback onTap;

  const HistoryListItem({super.key, required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Format date: "10:30 AM"
    final timeString = DateFormat.jm().format(record.timestamp);
    final l10n = AppLocalizations.of(context)!;

    // Determine color based on valence/arousal
    Color intensityColor = Colors.white;
    if (record.arousal != null && record.valence != null) {
      if (record.arousal! > 0) {
        intensityColor = record.valence! > 0
            ? AppColors.seedingSun
            : AppColors.seedingFire;
      } else {
        intensityColor = record.valence! > 0
            ? AppColors.seedingGrass
            : AppColors.seedingRain;
      }
    }

    final localizedEmotion = l10n.getLocalizedEmotion(
      record.emotionLabel ?? 'Untitled',
    );
    final detailText =
        record.automaticThought ??
        record.activities?.join(', ') ??
        'No details';

    return Semantics(
      label: "기록: $localizedEmotion, $detailText, 시간: $timeString",
      button: true,
      onTap: onTap,
      child: ZestGlassCard(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Emoji Placeholder
                ExcludeSemantics(
                  child: Container(
                    width: 48 * MediaQuery.textScalerOf(context).scale(1),
                    height: 48 * MediaQuery.textScalerOf(context).scale(1),
                    decoration: BoxDecoration(
                      color: intensityColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: intensityColor.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        record.emotionLabel?.substring(0, 1) ?? '😐',
                        style: TextStyle(
                          fontSize:
                              24 * MediaQuery.textScalerOf(context).scale(1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedEmotion,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: AppColors.fontWeightBold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detailText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeString,
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
