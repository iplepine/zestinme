import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/sleep_provider.dart';
import '../widgets/moon_time_dial.dart';

class SleepRecordScreen extends ConsumerWidget {
  const SleepRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepState = ref.watch(sleepNotifierProvider);
    final notifier = ref.read(sleepNotifierProvider.notifier);

    // Format times for display
    final timeFormat = DateFormat('HH:mm');
    final bedTimeStr = timeFormat.format(sleepState.bedTime);
    final wakeTimeStr = timeFormat.format(sleepState.wakeTime);

    final durationHours = sleepState.durationMinutes ~/ 60;
    final durationMins = sleepState.durationMinutes % 60;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Deep Indigo
      appBar: AppBar(
        title: const Text('Dreaming', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 1. Title
              const Text(
                '어젯밤, 푹 주무셨나요?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Moon Phase Dial (Visual Only for now, interactive logic is complex)
              // For MVP, we can use simple TimePickers below, and just show the dial visualization.
              SizedBox(
                height: 250,
                width: 250,
                child: InteractiveMoonTimeDial(
                  bedTime: sleepState.bedTime,
                  wakeTime: sleepState.wakeTime,
                  onBedTimeChanged: (newTime) {
                    notifier.updateTimes(newTime, sleepState.wakeTime);
                  },
                  onWakeTimeChanged: (newTime) {
                    notifier.updateTimes(sleepState.bedTime, newTime);
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 3. Time Display & Edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeColumn(context, '취침', bedTimeStr, () async {
                    // Pick Bed Time
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(sleepState.bedTime),
                    );
                    if (time != null) {
                      final newBedTime = DateTime(
                        sleepState.bedTime.year,
                        sleepState.bedTime.month,
                        sleepState.bedTime.day,
                        time.hour,
                        time.minute,
                      );
                      // Handling day boundaries is tricky with simple pickers.
                      // For MVP assume user picks correct time on relevant day.
                      // Or just update hours/mins.
                      notifier.updateTimes(newBedTime, sleepState.wakeTime);
                    }
                  }),
                  Column(
                    children: [
                      Text(
                        '$durationHours시간 $durationMins분',
                        style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.arrow_right_alt, color: Colors.white54),
                    ],
                  ),
                  _buildTimeColumn(context, '기상', wakeTimeStr, () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(sleepState.wakeTime),
                    );
                    if (time != null) {
                      final newWakeTime = DateTime(
                        sleepState.wakeTime.year,
                        sleepState.wakeTime.month,
                        sleepState.wakeTime.day,
                        time.hour,
                        time.minute,
                      );
                      notifier.updateTimes(sleepState.bedTime, newWakeTime);
                    }
                  }),
                ],
              ),

              const SizedBox(height: 50),

              // 4. Quality Slider (Emoji)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '개운함 정도',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.secondaryColor,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: AppTheme.secondaryColor.withOpacity(0.2),
                ),
                child: Slider(
                  value: sleepState.qualityScore.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _getEmojiForScore(sleepState.qualityScore),
                  onChanged: (val) => notifier.updateQuality(val.round()),
                ),
              ),
              Text(
                _getLabelForScore(sleepState.qualityScore),
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // 5. Factors (Alarm & Tags)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.secondaryColor, // Green/Lime
                title: const Text(
                  '알람 없이 눈이 떠졌나요?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  '자연스러운 기상은 꿀잠의 증거예요',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                value: sleepState.isNaturalWake,
                onChanged: notifier.toggleNaturalWake,
              ),

              const SizedBox(height: 12),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.secondaryColor,
                title: const Text(
                  '한 번에 일어났나요?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: Text(
                  '알람 끄고 다시 잠들지 않았어요',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                value: sleepState.isImmediateWake,
                onChanged: notifier.toggleImmediateWake,
              ),

              const SizedBox(height: 24),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '수면에 영향을 준 요인이 있나요?', // Updated Label
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SleepNotifier.factorTags.map((tag) {
                  final isSelected = sleepState.selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) {
                      notifier.toggleTag(tag);
                      HapticFeedback.selectionClick();
                    },
                    elevation: 0,
                    pressElevation: 0,
                    showCheckmark: false,
                    // Use a dark background explicitly as requested
                    backgroundColor: Colors.black.withValues(alpha: 0.2),
                    surfaceTintColor: Colors.transparent,
                    selectedColor: AppColors.seedingChipSelected,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.seedingChipTextSelected
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // 5. Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: sleepState.isSaving
                      ? null
                      : () async {
                          await notifier.saveRecord();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('수면 기록이 저장되었습니다. 🌙'),
                              ),
                            );
                            context.pop();
                          }
                        },
                  child: sleepState.isSaving
                      ? const CircularProgressIndicator()
                      : const Text('저장하기', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(
    BuildContext context,
    String label,
    String time,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmojiForScore(int score) {
    switch (score) {
      case 1:
        return '🧟';
      case 2:
        return '😫';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '✨';
      default:
        return '😐';
    }
  }

  String _getLabelForScore(int score) {
    switch (score) {
      case 1:
        return '정말 피곤해요';
      case 2:
        return '조금 힘들어요';
      case 3:
        return '그저 그래요';
      case 4:
        return '개운해요';
      case 5:
        return '상쾌해요!';
      default:
        return '보통이에요';
    }
  }
}
