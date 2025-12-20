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
  });

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
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
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
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
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
                  height: 56,
                  alignment: Alignment.center,
                  child: Icon(
                    _speechController.isListening ? Icons.mic : Icons.mic_none,
                    color: _speechController.isListening
                        ? Colors.redAccent
                        : (widget.style?.color?.withOpacity(0.5) ??
                              Colors.white54),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 4. Listening Status Hint
        SizedBox(
          height: 24,
          child: Visibility(
            visible: _speechController.isListening,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
              child:
                  Text(
                        '듣고 있어요... 👂',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fade(begin: 0.5, end: 1.0, duration: 600.ms)
                      .scaleXY(begin: 1.0, end: 1.1, duration: 600.ms),
            ),
          ),
        ),
      ],
    );
  }
}
