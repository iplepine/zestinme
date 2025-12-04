import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/emotion_write/presentation/providers/emotion_write_provider.dart';

class Step4Cognition extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const Step4Cognition({super.key, required this.onNext, required this.onPrev});

  @override
  ConsumerState<Step4Cognition> createState() => _Step4CognitionState();
}

class _Step4CognitionState extends ConsumerState<Step4Cognition> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(emotionWriteProvider).automaticThought,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'What is on your mind?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'e.g. I feel like I am falling behind...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => ref
                .read(emotionWriteProvider.notifier)
                .setAutomaticThought(value),
          ),

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onPrev,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onNext,
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
