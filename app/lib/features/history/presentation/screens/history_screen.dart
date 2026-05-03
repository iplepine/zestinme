import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/history_provider.dart';
import '../providers/self_understanding_provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/self_understanding_card.dart';
import '../widgets/timeline_widget.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyRecordsProvider);
    final weeklySummary = ref.watch(weeklySelfUnderstandingProvider);
    final selectedDate = ref.watch(historyDateProvider);
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0B1322),
                Color(0xFF141F33),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 8,
                  right: 20,
                  child: Row(
                    children: [
                      BackButton(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          isKo ? '컨디션 타임라인' : 'Condition Timeline',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 56,
                  left: 20,
                  right: 20,
                  child: Text(
                    isKo
                        ? '월별 흐름과 날짜별 기록을 보면서 언제 컨디션이 흔들렸는지 확인해보세요.'
                        : 'Review monthly flow and day-level entries to see when you dipped and how you recovered.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.46,
                  child: historyState.when(
                    data: (records) =>
                        CalendarWidget(records: records).animate().fadeIn(),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => Center(
                      child: Text(
                        isKo ? '기록을 불러오지 못했어요.' : 'Unable to load records.',
                      ),
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.45,
                  maxChildSize: 0.92,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF11192A),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          weeklySummary.when(
                            data: (summary) =>
                                SelfUnderstandingCard(summary: summary),
                            loading: () => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          Expanded(
                            child: historyState.when(
                              data: (records) {
                                final dayRecords = records.where((r) {
                                  return r.timestamp.year == selectedDate.year &&
                                      r.timestamp.month == selectedDate.month &&
                                      r.timestamp.day == selectedDate.day;
                                }).toList();

                                return TimelineWidget(
                                  records: dayRecords,
                                  scrollController: scrollController,
                                ).animate().fadeIn();
                              },
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
