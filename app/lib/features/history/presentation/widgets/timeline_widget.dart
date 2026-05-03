import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          '아직 기록이 없어요.\n오늘 컨디션 체크인이나 회복 로그를 남겨보세요.',
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
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _scoreColor(
                          _conditionScore(record),
                          Theme.of(context).colorScheme,
                        ),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _isSleepEntry(record)
                      ? _buildSleepCard(context, record)
                      : _buildConditionCard(context, record),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConditionCard(BuildContext context, EmotionRecord record) {
    final dateFormat = DateFormat('a h:mm', 'ko');
    final colorScheme = Theme.of(context).colorScheme;
    final score = _conditionScore(record);
    final accentColor = _scoreColor(score, colorScheme);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
                child: Text(
                  _conditionTitle(record, score),
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
              _InfoChip(label: '점수 ${score == 0 ? '-' : score.toStringAsFixed(0)}'),
              _InfoChip(label: '에너지 ${_dimensionLabel(record.valence)}'),
              _InfoChip(label: '집중 ${_dimensionLabel(record.arousal)}'),
              if (record.postCaringIntensity != null)
                _InfoChip(label: '회복 ${record.postCaringIntensity}'),
              ...(record.activities ?? const <String>[]).map(
                (tag) => _InfoChip(label: _conditionLabel(tag)),
              ),
              ...(record.bodySensations ?? const <String>[]).map(
                (tag) => _InfoChip(label: _conditionLabel(tag)),
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

  Widget _buildSleepCard(BuildContext context, EmotionRecord record) {
    final dateFormat = DateFormat('a h:mm', 'ko');
    final colorScheme = Theme.of(context).colorScheme;
    final score = _conditionScore(record);
    final accentColor = _scoreColor(score, colorScheme);
    final note = record.detailedNote?.isNotEmpty == true
        ? record.detailedNote!
        : '회복 로그';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
                child: Text(
                  '회복 로그',
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
              _InfoChip(label: '점수 ${score == 0 ? '-' : score.toStringAsFixed(0)}'),
              _InfoChip(label: '에너지 ${_dimensionLabel(record.valence)}'),
              _InfoChip(label: '집중 ${_dimensionLabel(record.arousal)}'),
              if (record.postCaringIntensity != null)
                _InfoChip(label: '회복감 ${record.postCaringIntensity}'),
              ...(record.activities ?? const <String>[]).map(
                (tag) => _InfoChip(label: _conditionLabel(tag)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _conditionLabel(String tag) {
    if (tag.startsWith('stress:')) {
      return '스트레스 ${tag.split(':').last}';
    }
    if (tag.startsWith('recovery:')) {
      return '회복 ${tag.split(':').last}';
    }
    if (tag.startsWith('efficiency:')) {
      return '효율 ${tag.split(':').last}';
    }
    if (tag.startsWith('refreshment:')) {
      return '회복감 ${tag.split(':').last}';
    }
    if (tag.startsWith('sleep-latency:')) {
      return '입면 ${tag.split(':').last}';
    }
    if (tag.startsWith('snooze:')) {
      return '스누즈 ${tag.split(':').last}회';
    }
    switch (tag) {
      case 'LockedIn':
        return '몰입됨';
      case 'Drained':
        return '지침';
      case 'Wired':
        return '과긴장';
      case 'Foggy':
        return '흐릿함';
      case 'Overloaded':
        return '벅참';
      case 'Steady':
        return '무난함';
      case 'Heavy':
        return '무거움';
      case 'Flat':
        return '무덤덤함';
      case 'Slipping':
        return '흐트러짐';
      case 'NeedsReset':
        return '재정비 필요';
      case 'Tense':
        return '긴장됨';
      case 'Restless':
        return '가라앉지 않음';
      case 'Pressed':
        return '쫓기는 느낌';
      case 'OnEdge':
        return '예민함';
      case 'Scattered':
        return '산만함';
      case 'Unfocused':
        return '집중 저하';
      case 'Sharp':
        return '선명함';
      case 'Recovered':
        return '회복됨';
      case 'Grounded':
        return '단단함';
      case 'Ready':
        return '준비됨';
      case 'Calm':
        return '차분함';
      case 'Balanced':
        return '균형 잡힘';
      case 'Stable':
        return '안정적';
      case 'Light':
        return '가벼움';
      case 'Building':
        return '올라오는 중';
      case 'Recovering':
        return '회복 중';
      case 'Work':
        return '일/업무';
      case 'Relationship':
        return '인간관계';
      case 'Family':
        return '가족';
      case 'Money':
        return '금전';
      case 'Health':
        return '건강';
      case 'SleepDebt':
        return '수면 부족';
      case 'Exercise':
        return '운동';
      case 'Deadline':
        return '마감';
      case 'Social':
        return '사람 만남';
      case 'Travel':
        return '이동';
      case 'Alone':
        return '혼자 있음';
      case 'Future':
        return '미래 걱정';
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
        return '기운 없음';
      case 'Sleepy':
        return '졸림';
      case 'EyeStrain':
        return '눈 피로';
      case 'ShallowBreath':
        return '얕은 호흡';
      case 'HeavyBody':
        return '몸이 무거움';
      case 'sleep':
        return '수면';
      case 'natural-wake':
        return '자연 기상';
      case 'fast-rise':
        return '개운한 기상';
      case 'condition-checkin':
        return '컨디션 체크인';
      case 'caffeine':
        return '카페인';
      case 'alcohol':
        return '알코올';
      case 'late-night-snack':
        return '야식';
      case 'fasting':
        return '공복';
      case 'screen-time':
        return '스크린타임';
      case 'intense-workout':
        return '격한 운동';
      case 'reading':
        return '명상/독서';
      case 'nap':
        return '낮잠';
      case 'noise':
        return '소음';
      case 'light':
        return '빛';
      case 'temperature':
        return '온도';
      case 'bed-change':
        return '잠자리 변경';
      case 'stress':
        return '스트레스';
      case 'hormone':
        return '호르몬';
      case 'pain':
        return '통증/질병';
      case 'nightmare':
        return '악몽';
      default:
        return tag;
    }
  }

  String _conditionTitle(EmotionRecord record, double score) {
    final label = record.emotionLabel;
    if (label != null && label.isNotEmpty && !label.toLowerCase().startsWith('sleep')) {
      return _conditionLabel(label);
    }
    if (score >= 80) return '최상 컨디션';
    if (score >= 65) return '안정적';
    if (score >= 45) return '조정 필요';
    return '회복 우선';
  }

  String _dimensionLabel(double? value) {
    if (value == null || value <= 0) return '-';
    return value.toStringAsFixed(1);
  }

  double _conditionScore(EmotionRecord record) {
    final score = record.intensity?.toDouble() ?? 0.0;
    if (score <= 0) return 0.0;
    return score * 10;
  }

  Color _scoreColor(double score, ColorScheme colorScheme) {
    if (score >= 80) return colorScheme.secondary;
    if (score >= 65) return colorScheme.primary;
    if (score >= 45) return Colors.amber;
    return Colors.deepOrangeAccent;
  }

  bool _isSleepEntry(EmotionRecord record) {
    final label = record.emotionLabel?.toLowerCase() ?? '';
    return label.startsWith('sleep');
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
