import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/history_provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/timeline_widget.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyRecordsProvider);
    final selectedDate = ref.watch(historyDateProvider);

    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to go behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '정원 일지',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        leading: BackButton(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceVariant,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // 1. Calendar Section (Top Background)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.55,
                child: historyState.when(
                  data: (records) =>
                      CalendarWidget(records: records).animate().fadeIn(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),

              // 2. Timeline Section (Expandable Bottom Sheet)
              DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.45,
                maxChildSize: 0.92,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E), // Slightly lighter dark
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
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // List
                        Expanded(
                          child: historyState.when(
                            data: (records) {
                              // Filter records for the selected date
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
          ), // Stack
        ), // SafeArea
      ), // Container
    ); // Scaffold
  }
}
