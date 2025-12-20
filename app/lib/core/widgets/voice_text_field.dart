import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zestinme/app/theme/app_theme.dart';
import 'speech_recognition_controller.dart';

class VoiceTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final InputDecoration? decoration;
  final TextStyle? style;

  const VoiceTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.decoration,
    this.style,
    this.onInputStarted,
  });

  final VoidCallback? onInputStarted;

  @override
  State<VoiceTextField> createState() => _VoiceTextFieldState();
}

class _VoiceTextFieldState extends State<VoiceTextField> {
  late final SpeechRecognitionController _speechController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _speechController = SpeechRecognitionController();

    _speechController.addListener(_onSpeechUpdate);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onInputStarted?.call();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _speechController.removeListener(_onSpeechUpdate);
    _speechController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSpeechUpdate() {
    if (!mounted) return;

    final newText = _speechController.fullText;

    // Update the TextField controller only if text has changed to avoid focus issues
    if (widget.controller.text != newText) {
      widget.controller.text = newText;
      widget.onChanged?.call(newText);

      // Maintain cursor at the end during dictation
      if (_speechController.isListening) {
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
      }

      _scrollToEnd();
    }

    // Refresh UI to sync mic icon and "listening" hint
    setState(() {});
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _handleMicTap() async {
    if (_speechController.isListening) {
      await _speechController.stop();
    } else {
      widget.onInputStarted?.call();
      _focusNode.requestFocus();
      await _speechController.start(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Input Container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.only(
            bottom: 10,
          ), // Add breathing room for counter
          decoration: BoxDecoration(
            color: _focusNode.hasFocus
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? Colors.white.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 2. TextField Area
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  scrollController: _scrollController,
                  onChanged: widget.onChanged,
                  style: widget.style ?? const TextStyle(color: Colors.white),
                  decoration: (widget.decoration ?? const InputDecoration())
                      .copyWith(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        counterStyle: TextStyle(
                          color:
                              widget.style?.color?.withOpacity(0.6) ??
                              Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                ),
              ),
              // 3. Mic Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleMicTap,
                child: Container(
                  width: 56,
                  constraints: const BoxConstraints(minHeight: 56),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_speechController.isListening)
                        Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent.withOpacity(0.2),
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .scale(
                              begin: const Offset(1.0, 1.0),
                              end: const Offset(2.0, 2.0),
                              duration: 1000.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeOut(duration: 1000.ms),
                      _speechController.isListening
                          ? Icon(Icons.mic, color: Colors.redAccent)
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .scale(
                                  begin: const Offset(1.0, 1.0),
                                  end: const Offset(1.1, 1.1),
                                  duration: 600.ms,
                                  curve: Curves.easeInOut,
                                )
                          : Icon(
                              Icons.mic_none,
                              color:
                                  widget.style?.color?.withOpacity(0.5) ??
                                  Colors.white54,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
