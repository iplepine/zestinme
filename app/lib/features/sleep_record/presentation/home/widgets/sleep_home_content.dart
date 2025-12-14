import 'package:flutter/material.dart';
import 'package:zestinme/core/models/sleep_record.dart';
import 'package:zestinme/features/sleep_record/presentation/widgets/sleep_history_chart.dart';
import 'package:zestinme/features/sleep_record/presentation/home/widgets/sleep_statistics.dart';

class SleepHomeContent extends StatelessWidget {
  final List<SleepRecord> records;
  final Function(SleepRecord) onBarLongPressed;

  const SleepHomeContent({
    super.key,
    required this.records,
    required this.onBarLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 120, // 버튼을 위한 여백
      ),
      child: Column(
        children: [
          // Δ 카드 섹션
          _buildDeltaCard(context),
          const SizedBox(height: 20),

          // 1분 미션 섹션
          _buildOneMinuteMission(context),
          const SizedBox(height: 20),

          // 차트 섹션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SleepHistoryChart(
              records: records,
              onBarLongPressed: onBarLongPressed,
            ),
          ),
          const SizedBox(height: 20),
          // 통계 정보
          if (records.isNotEmpty) SleepStatistics(records: records),
        ],
      ),
    );
  }

  Widget _buildDeltaCard(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 오늘의 수면 기록 찾기
    final todayRecord = records.where((record) {
      final recordDate = DateTime(
        record.bedTime.year,
        record.bedTime.month,
        record.bedTime.day,
      );
      // Check explicit date if available or just bedTime matches today's date (if sleeping after midnight? actually record date usually tracks wake up)
      // Core SleepRecord 'date' is usually wake date.
      // Let's check 'date' if initialized.
      // Safe check: record.date == today
      try {
        return record.date == today;
      } catch (e) {
        // Fallback if date not set (though it should be)
        return recordDate == today;
      }
    }).firstOrNull;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.purple[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.blue[600], size: 24),
              const SizedBox(width: 8),
              Text(
                '오늘의 Δ 카드',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (todayRecord != null) ...[
            // 수면 시간 계산
            Builder(
              builder: (context) {
                final sleepDuration = todayRecord.wakeTime.difference(
                  todayRecord.bedTime,
                );
                final hours = sleepDuration.inHours;
                final minutes = sleepDuration.inMinutes % 60;

                return Text(
                  '어젯밤 ${hours}h${minutes}m → 수면 품질 ${todayRecord.qualityScore}/5',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // 관련 태그 표시
            if (todayRecord.tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '방해요인: ${todayRecord.tags.join(', ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ] else ...[
            Text(
              '아직 오늘의 수면 기록이 없어요',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '밤에 잠든 시간을 기록해보세요!',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOneMinuteMission(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;

    // 시간대에 따른 미션 결정
    String mission;
    String description;
    IconData icon;
    Color color;

    if (hour >= 22 || hour < 6) {
      // 밤 시간대 (22시-6시)
      mission = '취침 1시간 전 스크린 Off 체크';
      description = '잠들기 1시간 전에 스마트폰을 멀리 두세요';
      icon = Icons.phone_android;
      color = Colors.indigo;
    } else if (hour >= 6 && hour < 10) {
      // 아침 시간대 (6시-10시)
      mission = '아침 상쾌도 체크';
      description = '기상 후 컨디션을 기록해보세요';
      icon = Icons.wb_sunny;
      color = Colors.orange;
    } else {
      // 낮 시간대
      mission = '오늘의 수면 목표 확인';
      description = '오늘 밤의 수면 목표를 세워보세요';
      icon = Icons.flag;
      color = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1분 미션',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mission,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // 미션 완료 체크
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$mission 완료! 🎉'),
                  backgroundColor: color,
                ),
              );
            },
            icon: Icon(Icons.check_circle_outline, color: color),
          ),
        ],
      ),
    );
  }
}
