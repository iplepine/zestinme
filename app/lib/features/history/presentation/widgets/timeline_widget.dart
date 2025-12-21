import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/l10n/app_localizations.dart';
import '../../../../core/utils/emotion_localization_utils.dart';
import '../../../../core/models/emotion_record.dart';

class TimelineWidget extends StatelessWidget {
  final List<EmotionRecord> records;
  final ScrollController? scrollController;

  const TimelineWidget({
    super.key,
    required this.records,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          "아직 수확한 마음이 없네요.\n오늘의 씨앗을 심어보세요.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.5), height: 1.5),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final isLast = index == records.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Timeline Line (Stem)
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
              ),

              // 2. Card Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildRecordCard(context, record),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordCard(BuildContext context, EmotionRecord record) {
    final dateFormat = DateFormat('a h:mm', 'ko'); // e.g. 오후 3:30
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Determine card accent color based on valence
    Color accentColor;
    if ((record.valence ?? 0) > 0) {
      accentColor = colorScheme.secondary; // Lime
    } else {
      accentColor = Colors.blueAccent; // Sad/Blue
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20), // More organic
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                // Wrapped emotion label in Flexible as per instruction
                child: Text(
                  l10n.getLocalizedEmotion(record.emotionLabel ?? ""),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dateFormat.format(record.timestamp),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (record.detailedNote != null &&
              record.detailedNote!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              record.detailedNote!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
