import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

class SceneIdentity extends ConsumerStatefulWidget {
  final VoidCallback onNameSubmitted;

  const SceneIdentity({super.key, required this.onNameSubmitted});

  @override
  ConsumerState<SceneIdentity> createState() => _SceneIdentityState();
}

class _SceneIdentityState extends ConsumerState<SceneIdentity> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background (Slightly clearer than Void)
        Container(color: const Color(0xFF0A101C)),

        Center(
          child:
              Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.badge,
                          size: 48,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "글씨가 물에 번져 흐릿하네요.\n뭐라고 적혀 있었나요?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "이름을 입력하세요",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _submitName(value);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              _submitName(_controller.text);
                            }
                          },
                          child: const Text("확인"),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.easeOutBack)
                  .fadeIn(),
        ),
      ],
    );
  }

  void _submitName(String name) {
    HapticFeedback.selectionClick();
    ref.read(onboardingControllerProvider.notifier).setNickname(name);
    widget.onNameSubmitted();
  }
}
