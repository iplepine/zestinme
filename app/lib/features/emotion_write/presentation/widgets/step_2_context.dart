import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/emotion_write/presentation/providers/emotion_write_provider.dart';

class Step2Context extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const Step2Context({super.key, required this.onNext, required this.onPrev});

  final List<String> _activities = const [
    'Work',
    'Study',
    'Meal',
    'Commute',
    'Rest',
    'Exercise',
    'Sleep',
  ];
  final List<String> _people = const [
    'Alone',
    'Family',
    'Friend',
    'Colleague',
    'Partner',
  ];
  final List<String> _locations = const [
    'Home',
    'Office',
    'School',
    'Cafe',
    'Outdoors',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emotionWrite = ref.watch(emotionWriteProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'What is happening?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          _buildSection(
            title: 'Activity',
            items: _activities,
            selectedItems: emotionWrite.activities ?? [],
            onSelected: (item) =>
                ref.read(emotionWriteProvider.notifier).toggleActivity(item),
          ),
          const SizedBox(height: 20),

          _buildSection(
            title: 'People',
            items: _people,
            selectedItems: emotionWrite.people ?? [],
            onSelected: (item) =>
                ref.read(emotionWriteProvider.notifier).togglePerson(item),
          ),
          const SizedBox(height: 20),

          _buildSection(
            title: 'Location',
            items: _locations,
            selectedItems: emotionWrite.location != null
                ? [emotionWrite.location!]
                : [],
            onSelected: (item) =>
                ref.read(emotionWriteProvider.notifier).setLocation(item),
            isSingle: true,
          ),

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrev,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required List<String> selectedItems,
    required Function(String) onSelected,
    bool isSingle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onSelected(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
