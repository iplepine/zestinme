import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import '../../../../core/models/emotion_record.dart';

class TimelineWidget extends StatelessWidget {
  final List<EmotionRecord> records;

  const TimelineWidget({super.key, required this.records});

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
      padding: const EdgeInsets.all(20),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        final isLast = index == records.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Timeline Line
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.emotionLabel ?? "무제",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                dateFormat.format(record.timestamp),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
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
                color: Colors.white.withValues(alpha: 0.8),
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
