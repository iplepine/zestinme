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
  String _baselineText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _isSpeechEnabled = await _speechToText.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // dispose 시 백그라운드 리스닝이 남지 않도록 정리
    _speechToText.stop();
    _speechToText.cancel();
    super.dispose();
  }

  void _startListening() async {
    if (!_isSpeechEnabled) return;
    if (_isListening) return;

    _baselineText = widget.controller.text;

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
      // Press & hold 방식: 사용자가 버튼을 떼는 순간 종료하므로,
      // 무음 감지로 너무 빨리 멈추지 않게 pauseFor 를 길게 둡니다.
      pauseFor: const Duration(minutes: 5),
      listenMode: ListenMode.dictation,
      partialResults: true,
      onResult: (result) {
        if (mounted) {
          final recognized = result.recognizedWords.trim();
          final nextText = recognized.isEmpty
              ? _baselineText
              : (_baselineText.trim().isEmpty
                    ? recognized
                    : '${_baselineText.trim()} $recognized');

          // Update controller
          widget.controller.text = nextText;
          // Notify change
          widget.onChanged?.call(nextText);

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
    if (!_isListening) return;
    await _speechToText.stop();
    // Haptic Feedback: Stop
    HapticFeedback.lightImpact();

    setState(() {
      _isListening = false;
    });
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
      suffixIcon: Tooltip(
        message: _isSpeechEnabled
            ? (_isListening ? '손을 떼면 입력이 끝나요' : '길게 눌러 말하기')
            : '음성 입력을 사용할 수 없어요',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _isSpeechEnabled ? (_) => _startListening() : null,
          onTapUp: _isSpeechEnabled ? (_) => _stopListening() : null,
          onTapCancel: _isSpeechEnabled ? _stopListening : null,
          child: Semantics(
            button: true,
            enabled: _isSpeechEnabled,
            label: '음성 입력',
            hint: '길게 눌러 말하기',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: !_isSpeechEnabled
                    ? Colors.white24
                    : (_isListening
                          ? Colors.redAccent
                          : (widget.style?.color?.withOpacity(0.5) ??
                                Colors.white54)),
              ),
            ),
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
          child: _isListening
              ? Text(
                    '말하는 동안 버튼을 누르고 계세요',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fade(begin: 0.5, end: 1.0, duration: 600.ms)
                  .scaleXY(begin: 1.0, end: 1.1, duration: 600.ms)
              : Text(
                  _isSpeechEnabled
                      ? '마이크를 길게 눌러 말해보세요'
                      : '음성 입력을 사용할 수 없어요 (권한을 확인해주세요)',
                  style: TextStyle(
                    color: _isSpeechEnabled
                        ? Colors.white38
                        : Colors.white30,
                    fontSize: 12,
                  ),
                ),
        ),
      ],
    );
  }
}
