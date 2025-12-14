import 'package:flutter/material.dart';
import 'package:zestinme/core/models/sleep_record.dart';

class SleepStatistics extends StatelessWidget {
  final List<SleepRecord> records;

  const SleepStatistics({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final double totalHours = records.fold<double>(
      0,
      (sum, record) => sum + (record.durationMinutes / 60.0),
    );
    final avgHours = records.isEmpty ? 0.0 : totalHours / records.length;

    final double totalScore = records.fold<double>(
      0,
      (sum, record) => sum + record.qualityScore,
    );
    final avgScore = records.isEmpty ? 0.0 : totalScore / records.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('평균 수면', '${avgHours.toStringAsFixed(1)}시간'),
          _buildStatItem('평균 점수', '${avgScore.toStringAsFixed(1)}점'),
          _buildStatItem('기록 수', '${records.length}개'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
