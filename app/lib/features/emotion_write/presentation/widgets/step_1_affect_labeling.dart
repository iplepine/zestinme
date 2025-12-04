import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/emotion_write/presentation/providers/emotion_write_provider.dart';

class Step1AffectLabeling extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const Step1AffectLabeling({super.key, required this.onNext});

  @override
  ConsumerState<Step1AffectLabeling> createState() =>
      _Step1AffectLabelingState();
}

class _Step1AffectLabelingState extends ConsumerState<Step1AffectLabeling> {
  // Mock candidates for MVP
  final List<String> _candidates = [
    'Happy',
    'Excited',
    'Calm',
    'Relaxed',
    'Angry',
    'Anxious',
    'Sad',
    'Bored',
  ];
  String? _selectedEmotion;

  @override
  Widget build(BuildContext context) {
    final emotionWrite = ref.watch(emotionWriteProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    _updateCoordinates(
                      details.localPosition,
                      constraints.biggest,
                    );
                  },
                  onTapDown: (details) {
                    _updateCoordinates(
                      details.localPosition,
                      constraints.biggest,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Stack(
                      children: [
                        // Grid Lines
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.grey[300],
                          ),
                        ),
                        // Labels
                        const Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Text(
                            'High Energy',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Text(
                            'Low Energy',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                'Unpleasant',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                'Pleasant',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        // Cursor
                        if (emotionWrite.valence != null &&
                            emotionWrite.arousal != null)
                          Positioned(
                            left:
                                _mapValenceToX(
                                  emotionWrite.valence!,
                                  constraints.maxWidth,
                                ) -
                                10,
                            top:
                                _mapArousalToY(
                                  emotionWrite.arousal!,
                                  constraints.maxHeight,
                                ) -
                                10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _candidates.map((emotion) {
              final isSelected = _selectedEmotion == emotion;
              return ChoiceChip(
                label: Text(emotion),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedEmotion = selected ? emotion : null;
                  });
                  if (selected) {
                    ref
                        .read(emotionWriteProvider.notifier)
                        .setEmotionLabel(emotion);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedEmotion != null ? widget.onNext : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  void _updateCoordinates(Offset localPosition, Size size) {
    // Map localPosition to Valence (-5 to 5) and Arousal (0 to 10)
    // X: 0 -> -5, Width -> 5
    // Y: 0 -> 10 (High), Height -> 0 (Low) - Note: Y is inverted in UI

    double x = localPosition.dx.clamp(0, size.width);
    double y = localPosition.dy.clamp(0, size.height);

    double valence = (x / size.width) * 10 - 5;
    double arousal = 10 - (y / size.height) * 10;

    ref
        .read(emotionWriteProvider.notifier)
        .updateValenceArousal(valence, arousal);
  }

  double _mapValenceToX(double valence, double width) {
    // -5 -> 0, 5 -> width
    return (valence + 5) / 10 * width;
  }

  double _mapArousalToY(double arousal, double height) {
    // 10 -> 0, 0 -> height
    return (10 - arousal) / 10 * height;
  }
}
