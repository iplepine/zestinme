import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/history_provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/timeline_widget.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyRecordsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('정원 일지', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. Calendar Section (Top)
          // 1. Calendar Section (Top)
          historyState.when(
            data: (records) =>
                CalendarWidget(records: records).animate().fadeIn(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),

          // 2. Timeline Section (Bottom Sheet style)
          Expanded(
            flex: 3, // 3/5 of screen
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E), // Slightly lighter dark
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List
                  Expanded(
                    child: historyState.when(
                      data: (records) => TimelineWidget(
                        records: records,
                      ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
