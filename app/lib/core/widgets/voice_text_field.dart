import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zestinme/app/theme/app_theme.dart';

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
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _isSpeechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _isSpeechEnabled = await _speechToText.initialize();
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (!_isSpeechEnabled) return;

    // Haptic Feedback: Start
    HapticFeedback.mediumImpact();

    // Auto-Scroll logic
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });

    await _speechToText.listen(
      pauseFor: const Duration(seconds: 3), // Auto-stop after 3s silence
      onResult: (result) {
        if (mounted) {
          // Update controller
          widget.controller.text = result.recognizedWords;
          // Notify change
          widget.onChanged?.call(result.recognizedWords);

          // Force cursor to end
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          );
        }
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    // Haptic Feedback: Stop
    HapticFeedback.lightImpact();

    setState(() {
      _isListening = false;
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Base decoration
    final baseDecoration =
        widget.decoration ??
        InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        );

    // Merge suffix icon
    final inputDecoration = baseDecoration.copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color: _isListening
              ? Colors.redAccent
              : (widget.style?.color?.withOpacity(0.5) ?? Colors.white54),
        ),
        onPressed: _isSpeechEnabled ? _toggleListening : null,
        tooltip: '음성 입력 (STT)',
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: widget.style ?? const TextStyle(color: Colors.white),
          decoration: inputDecoration,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
        ),
        if (_isListening)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child:
                Text(
                      '듣고 있어요... 👂',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(begin: 0.5, end: 1.0, duration: 600.ms)
                    .scaleXY(begin: 1.0, end: 1.1, duration: 600.ms),
          ),
      ],
    );
  }
}
