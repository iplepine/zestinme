import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/l10n/app_localizations.dart';
import 'package:zestinme/core/utils/emotion_localization_utils.dart';
import 'package:zestinme/core/models/emotion_record.dart';

class HistoryListItem extends StatelessWidget {
  final EmotionRecord record;
  final VoidCallback onTap;

  const HistoryListItem({super.key, required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Format date: "10:30 AM"
    final timeString = DateFormat.jm().format(record.timestamp);
    final l10n = AppLocalizations.of(context)!;

    // Determine color based on valence/arousal (simplified for MVP)
    Color cardColor = Colors.grey[100]!;
    if (record.valence != null) {
      if (record.valence! > 0) {
        cardColor = Colors.amber[100]!; // Pleasant
      } else {
        cardColor = Colors.blue[100]!; // Unpleasant
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Emoji Placeholder
              Container(
                width:
                    48 *
                    MediaQuery.textScalerOf(context).scale(1) /
                    1.0, // Scale proportionally
                height: 48 * MediaQuery.textScalerOf(context).scale(1) / 1.0,
                decoration: const BoxDecoration(
                  color: Colors.white54,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('😐', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.getLocalizedEmotion(
                        record.emotionLabel ?? 'Untitled',
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.automaticThought ??
                          record.activities?.join(', ') ??
                          'No details',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                timeString,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
