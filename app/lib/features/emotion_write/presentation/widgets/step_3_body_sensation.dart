import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/emotion_write/presentation/providers/emotion_write_provider.dart';

class Step3BodySensation extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const Step3BodySensation({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  final List<String> _sensations = const [
    'Headache',
    'Dizziness',
    'Heart Racing',
    'Chest Tightness',
    'Stomach Ache',
    'Nausea',
    'Sweating',
    'Shaking',
    'Tension',
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
            'What does your body feel?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _sensations.map((sensation) {
              final isSelected =
                  emotionWrite.bodySensations?.contains(sensation) ?? false;
              return FilterChip(
                label: Text(sensation),
                selected: isSelected,
                onSelected: (_) => ref
                    .read(emotionWriteProvider.notifier)
                    .toggleBodySensation(sensation),
              );
            }).toList(),
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
}
