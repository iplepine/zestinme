import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Controller to encapsulate all Speech-to-Text logic.
/// Handles initialization, session tracking, buffering, and robust restarts.
class SpeechRecognitionController extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();

  bool _isListening = false;
  bool _isInitialized = false;

  // Buffering
  String _committedText = '';
  String _currentSessionText = '';
  int _currentSessionId = 0;
  Timer? _silenceTimer;

  // Getters
  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  String get fullText {
    if (_currentSessionText.isEmpty) return _committedText;
    final separator =
        (_committedText.isNotEmpty && !_committedText.endsWith(' ')) ? ' ' : '';
    return '$_committedText$separator$_currentSessionText';
  }

  /// Initialize the engine and handle permissions.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _isInitialized = await _speechToText.initialize(
      onStatus: _handleStatus,
      onError: _handleError,
    );
    return _isInitialized;
  }

  void _handleStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _processSessionEnd();
    }
  }

  void _handleError(dynamic error) {
    debugPrint('SpeechRecognitionController Error: $error');
    stop(); // Stop on terminal error
  }

  /// Start listening.
  Future<void> start(String initialText) async {
    if (_isListening) return;

    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return;
    }

    _committedText = initialText;
    _currentSessionText = '';
    _isListening = true;
    _currentSessionId++;

    await _listen();
    notifyListeners();
  }

  /// Stop listening and clean up.
  Future<void> stop() async {
    if (!_isListening) return;

    _isListening = false;
    _silenceTimer?.cancel();
    _silenceTimer = null;
    await _speechToText.stop();

    // Final commit
    _commitCurrentSession();
    notifyListeners();
  }

  Future<void> _listen() async {
    if (!_isListening) return;

    final sessionId = _currentSessionId;

    await _speechToText.listen(
      listenMode: ListenMode.dictation,
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(minutes: 5),
      cancelOnError: false,
      onResult: (result) {
        if (_isListening && _currentSessionId == sessionId) {
          // Speech detected, cancel silence timer
          _silenceTimer?.cancel();
          _silenceTimer = null;

          _currentSessionText = result.recognizedWords;
          notifyListeners();
        }
      },
    );

    // Initial Silence Timer: If no speech is detected within 5 seconds, stop.
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 5), () {
      if (_isListening &&
          _currentSessionId == sessionId &&
          _currentSessionText.isEmpty) {
        stop();
      }
    });
  }

  Future<void> _processSessionEnd() async {
    if (!_isListening) return;

    // Grace Period: Wait 1 second to catch trailing words
    // The engine might be 'done' but still have a final result in flight.
    await Future.delayed(const Duration(seconds: 1));

    // Stall Detection: If this session heard something, restart.
    if (_currentSessionText.isNotEmpty) {
      _commitCurrentSession();
      _restart();
    } else {
      // Nothing heard -> Auto-off
      stop();
    }
  }

  void _commitCurrentSession() {
    if (_currentSessionText.isEmpty) return;

    final separator =
        (_committedText.isNotEmpty && !_committedText.endsWith(' ')) ? ' ' : '';
    _committedText = '$_committedText$separator$_currentSessionText';
    _currentSessionText = '';
  }

  Future<void> _restart() async {
    if (!_isListening) return;

    _currentSessionId++;

    // Cooling delay for hardware release
    await Future.delayed(const Duration(milliseconds: 300));

    if (_isListening) {
      await _listen();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _speechToText.cancel();
    super.dispose();
  }
}
