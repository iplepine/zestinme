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
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            height: 1.5,
          ),
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
                          ).colorScheme.primary.withValues(alpha: 0.3),
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
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
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
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(label: '강도 ${record.intensity ?? '-'}'),
              if (record.postCaringIntensity != null)
                _InfoChip(label: '회고 후 ${record.postCaringIntensity}'),
              ...(record.activities ?? const <String>[]).map(
                (tag) => _InfoChip(label: _contextLabel(tag)),
              ),
              ...(record.bodySensations ?? const <String>[]).map(
                (tag) => _InfoChip(label: _bodyLabel(tag)),
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
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _contextLabel(String tag) {
    switch (tag) {
      case 'Work':
        return '일/공부';
      case 'Relationship':
        return '관계';
      case 'Family':
        return '가족';
      case 'Money':
        return '돈';
      case 'Health':
        return '건강';
      case 'SleepDebt':
        return '수면 부족';
      case 'Alone':
        return '혼자 있음';
      case 'Future':
        return '미래 걱정';
      case 'Mistake':
        return '실수/후회';
      case 'Comparison':
        return '비교';
      case 'Overload':
        return '과부하';
      case 'NoRest':
        return '휴식 부족';
      default:
        return tag;
    }
  }

  String _bodyLabel(String tag) {
    switch (tag) {
      case 'ChestTight':
        return '가슴 답답함';
      case 'ShoulderTension':
        return '목/어깨 긴장';
      case 'Headache':
        return '두통';
      case 'Stomach':
        return '속 불편함';
      case 'Heartbeat':
        return '심장 두근거림';
      case 'Fatigue':
        return '피로감';
      case 'LowEnergy':
        return '무기력';
      case 'Sleepy':
        return '졸림';
      case 'EyeStrain':
        return '눈 피로';
      case 'ShallowBreath':
        return '숨이 얕음';
      default:
        return tag;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white60, fontSize: 11),
      ),
    );
  }
}
