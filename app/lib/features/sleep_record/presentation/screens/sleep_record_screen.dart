import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/voice_text_field.dart';

import '../providers/sleep_provider.dart';
import '../widgets/moon_time_dial.dart';
import '../../../../core/widgets/zest_filter_chip.dart';

import '../../../../core/models/sleep_record.dart';
import '../../../../core/localization/app_localizations.dart';

class SleepRecordScreen extends ConsumerStatefulWidget {
  final SleepRecord? initialRecord;

  const SleepRecordScreen({super.key, this.initialRecord});

  @override
  ConsumerState<SleepRecordScreen> createState() => _SleepRecordScreenState();
}

class _SleepRecordScreenState extends ConsumerState<SleepRecordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialRecord != null) {
        ref
            .read(sleepNotifierProvider.notifier)
            .initializeWithRecord(widget.initialRecord!);
      } else {
        // Smart Time Default:
        // 04:00 ~ 18:00 -> Set WakeTime = Now (Running late or just woke up)
        // 18:00 ~ 04:00 -> Set BedTime = Now (Going to bed)
        final now = DateTime.now();
        final hour = now.hour;
        final state = ref.read(sleepNotifierProvider);
        final notifier = ref.read(sleepNotifierProvider.notifier);

        if (hour >= 4 && hour < 18) {
          notifier.updateTimes(state.inBedTime, now);
        } else {
          notifier.updateTimes(now, state.wakeTime);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sleepState = ref.watch(sleepNotifierProvider);
    final notifier = ref.read(sleepNotifierProvider.notifier);

    // Format times for display
    final timeFormat = DateFormat('HH:mm');
    final bedTimeStr = timeFormat.format(sleepState.inBedTime);
    final wakeTimeStr = timeFormat.format(sleepState.wakeTime);

    final durationHours = sleepState.durationMinutes ~/ 60;
    final durationMins = sleepState.durationMinutes % 60;

    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).sleepDiveTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              // 1. Title & Description
              Center(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).sleepDiveSubtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).sleepDiveDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 2. Moon Phase Dial & Battery Visualization
              Center(
                child: SizedBox(
                  height: 240,
                  width: 240,
                  child: InteractiveMoonTimeDial(
                    inBedTime: sleepState.inBedTime,
                    wakeTime: sleepState.wakeTime,
                    onInBedTimeChanged: (newTime) {
                      notifier.updateTimes(newTime, sleepState.wakeTime);
                    },
                    onWakeTimeChanged: (newTime) {
                      notifier.updateTimes(sleepState.inBedTime, newTime);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 3. Time Display & Edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeColumn(
                    context,
                    AppLocalizations.of(context).sleepDiveBedtimeLabel,
                    bedTimeStr,
                    () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          sleepState.inBedTime,
                        ),
                      );
                      if (time != null) {
                        final newBedTime = DateTime(
                          sleepState.inBedTime.year,
                          sleepState.inBedTime.month,
                          sleepState.inBedTime.day,
                          time.hour,
                          time.minute,
                        );
                        notifier.updateTimes(newBedTime, sleepState.wakeTime);
                      }
                    },
                  ),
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
                  _buildTimeColumn(
                    context,
                    AppLocalizations.of(context).sleepDiveWaketimeLabel,
                    wakeTimeStr,
                    () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          sleepState.wakeTime,
                        ),
                      );
                      if (time != null) {
                        final newWakeTime = DateTime(
                          sleepState.wakeTime.year,
                          sleepState.wakeTime.month,
                          sleepState.wakeTime.day,
                          time.hour,
                          time.minute,
                        );
                        notifier.updateTimes(sleepState.inBedTime, newWakeTime);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 3.5 Golden Hour Feedback
              _buildGoldenHourBanner(sleepState),

              // 3.8 Sleep Latency (입면 잠복기)
              Text(
                AppLocalizations.of(context).sleepDiveLatencyTitle,
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sleepState.sleepLatencyMinutes}분',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getLatencyLabel(sleepState.sleepLatencyMinutes),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.secondaryColor,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      trackHeight: 6.0,
                      overlayColor: AppTheme.secondaryColor.withValues(
                        alpha: 0.2,
                      ),
                    ),
                    child: Slider(
                      value: sleepState.sleepLatencyMinutes.toDouble().clamp(
                        0,
                        60,
                      ),
                      min: 0,
                      max: 60,
                      divisions: 12, // 5 min steps
                      label: '${sleepState.sleepLatencyMinutes}분',
                      onChanged: (val) {
                        HapticFeedback.selectionClick();
                        notifier.updateSleepLatency(val.round());
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '바로 잠듦',
                        style: TextStyle(color: Colors.white30, fontSize: 12),
                      ),
                      Text(
                        '1시간 이상',
                        style: TextStyle(color: Colors.white30, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.white10),
              const SizedBox(height: 20),

              // 4. Morning Check-in Flow

              // 4.1 Refreshment Slider
              Text(
                AppLocalizations.of(context).sleepDiveRefreshmentTitle,
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sleepState.selfRefreshmentScore}점',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getRefreshmentLabel(sleepState.selfRefreshmentScore),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.secondaryColor,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  trackHeight: 6.0,
                  overlayColor: AppTheme.secondaryColor.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: sleepState.selfRefreshmentScore.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    notifier.updateRefreshmentScore(val.round());
                    // Auto-map 0-100 to 1-5 quality score for legacy support
                    final legacyScore = (val / 20).ceil().clamp(1, 5).toInt();
                    notifier.updateQuality(legacyScore);
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 4.2 Wake Type
              Text(
                '기상 상태',
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeColor: AppTheme.secondaryColor,
                      title: Text(
                        AppLocalizations.of(context).sleepDiveNaturalWake,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: sleepState.isNaturalWake,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        notifier.toggleNaturalWake(val);
                      },
                    ),
                    const Divider(color: Colors.white10),
                    SwitchListTile(
                      activeColor: AppTheme.secondaryColor,
                      title: Text(
                        AppLocalizations.of(context).sleepDiveImmediateWake,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        '다시 잠들지 않았어요 (No Snooze)',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      value: sleepState.isImmediateWake,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        notifier.toggleImmediateWake(val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 4.3 Categorized Factors
              Text(
                AppLocalizations.of(context).sleepDiveFactorsTitle,
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              ...SleepNotifier.categorizedTags.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value.map((tag) {
                        final isSelected = sleepState.selectedTags.contains(
                          tag,
                        );
                        return ZestFilterChip(
                          label: tag,
                          isSelected: isSelected,
                          onSelected: (_) {
                            HapticFeedback.selectionClick();
                            notifier.toggleTag(tag);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              // 4.4 Memo (Optional)
              _MemoSection(
                initialMemo: sleepState.memo,
                onChanged: notifier.updateMemo,
              ),

              const SizedBox(height: 40),

              // 5. Save Button
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: sleepState.isSaving
                        ? null
                        : () async {
                            HapticFeedback.mediumImpact();
                            await notifier.saveRecord();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('수면 기록이 저장되었습니다. ⚡️'),
                                  backgroundColor: Color(0xFF1E2632),
                                ),
                              );
                              context.pop();
                            }
                          },
                    child: sleepState.isSaving
                        ? const CircularProgressIndicator()
                        : Text(
                            AppLocalizations.of(context).sleepDiveButtonFinish,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                // End Constraints/SizedBox
              ),
              const SizedBox(height: 120),
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

  Widget _buildGoldenHourBanner(SleepState sleepState) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sleepState.isGoldenHour
            ? AppColors.seedingSun.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: sleepState.isGoldenHour
              ? AppColors.seedingSun.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            sleepState.isGoldenHour
                ? Icons.battery_charging_full_rounded
                : Icons.battery_std_rounded,
            color: sleepState.isGoldenHour
                ? AppColors.seedingSun
                : Colors.white54,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sleepState.isGoldenHour ? 'Golden Hour 달성! ✨' : '수면 사이클 확인',
                style: TextStyle(
                  color: sleepState.isGoldenHour
                      ? AppColors.seedingSun
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${sleepState.sleepCycles.toStringAsFixed(1)} 사이클 (약 ${(sleepState.sleepCycles * 90).round()}분)',
                style: TextStyle(
                  color: sleepState.isGoldenHour
                      ? AppColors.seedingSun.withValues(alpha: 0.8)
                      : Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRefreshmentLabel(int score) {
    if (score >= 90) return '✨ 날아갈 것 같아요';
    if (score >= 70) return '🙂 상쾌해요';
    if (score >= 50) return '😐 괜찮아요';
    if (score >= 30) return '😫 피곤해요';
    return '🧟 좀비 상태...';
  }

  String _getLatencyLabel(int minutes) {
    if (minutes <= 5) return '🚀 기절 (5분 미만)';
    if (minutes <= 15) return '😌 양호 (15분)';
    if (minutes <= 30) return '🤔 보통 (30분)';
    return '😵 뒤척임 (1시간 이상)';
  }
}

class _MemoSection extends StatefulWidget {
  final String? initialMemo;
  final ValueChanged<String> onChanged;

  const _MemoSection({required this.initialMemo, required this.onChanged});

  @override
  State<_MemoSection> createState() => _MemoSectionState();
}

class _MemoSectionState extends State<_MemoSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMemo);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '한줄 메모 (Optional)',
          style: TextStyle(
            color: AppTheme.secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        VoiceTextField(
          controller: _controller,
          onChanged: widget.onChanged,
          hintText: '더 남기고 싶은 기록이 있나요?',
          maxLength: 200,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
