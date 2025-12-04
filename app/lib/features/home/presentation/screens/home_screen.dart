import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zestinme/features/history/presentation/providers/history_provider.dart';
import 'package:zestinme/features/history/presentation/widgets/history_list_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final today = DateFormat('MMMM d, EEEE').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(today, style: Theme.of(context).textTheme.bodySmall),
            const Text(
              'Hello, Basil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main CTA Area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder for Lottie/Image
                    const Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 80,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'How are you feeling now?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => context.push('/write'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Record Emotion'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Recent History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.push('/history'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              flex: 2,
              child: historyAsync.when(
                data: (records) {
                  if (records.isEmpty) {
                    return const Center(child: Text('No records yet.'));
                  }
                  // Show top 3
                  final recentRecords = records.take(3).toList();
                  return ListView.builder(
                    itemCount: recentRecords.length,
                    itemBuilder: (context, index) {
                      return HistoryListItem(
                        record: recentRecords[index],
                        onTap: () {},
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
