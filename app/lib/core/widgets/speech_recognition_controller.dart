import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Controller to encapsulate all Speech-to-Text logic.
/// Handles initialization, session tracking, buffering, and robust restarts.
class SpeechRecognitionController extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();

  bool _isListening = false;
  bool _isInitialized = false;
  bool _isDisposed = false;

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
    if (_isDisposed) return false;
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speechToText.initialize(
        onStatus: _handleStatus,
        onError: _handleError,
      );
    } catch (e) {
      debugPrint('SpeechRecognitionController Initialization Error: $e');
      _isInitialized = false;
    }
    return _isInitialized;
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _handleStatus(String status) {
    if (_isDisposed) return;
    if (status == 'done' || status == 'notListening') {
      _processSessionEnd();
    }
  }

  void _handleError(dynamic error) {
    if (_isDisposed) return;
    debugPrint('SpeechRecognitionController Error: $error');
    stop(); // Stop on terminal error
  }

  /// Start listening.
  Future<void> start(String initialText) async {
    if (_isDisposed || _isListening) return;

    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok || _isDisposed) return;
    }

    _committedText = initialText;
    _currentSessionText = '';
    _isListening = true;
    _currentSessionId++;

    await _listen();
    _safeNotify();
  }

  /// Stop listening and clean up.
  Future<void> stop() async {
    if (_isDisposed || !_isListening) return;

    _isListening = false;
    _silenceTimer?.cancel();
    _silenceTimer = null;
    await _speechToText.stop();

    if (_isDisposed) return;

    // Final commit
    _commitCurrentSession();
    _safeNotify();
  }

  Future<void> _listen() async {
    if (_isDisposed || !_isListening) return;

    final sessionId = _currentSessionId;

    await _speechToText.listen(
      listenMode: ListenMode.dictation,
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(minutes: 5),
      cancelOnError: false,
      onResult: (result) {
        if (_isDisposed) return;
        if (_isListening && _currentSessionId == sessionId) {
          // Speech detected, cancel silence timer
          _silenceTimer?.cancel();
          _silenceTimer = null;

          _currentSessionText = result.recognizedWords;
          _safeNotify();
        }
      },
    );

    if (_isDisposed) return;

    // Initial Silence Timer: If no speech is detected within 5 seconds, stop.
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 5), () {
      if (_isDisposed) return;
      if (_isListening &&
          _currentSessionId == sessionId &&
          _currentSessionText.isEmpty) {
        stop();
      }
    });
  }

  Future<void> _processSessionEnd() async {
    if (_isDisposed || !_isListening) return;

    // Grace Period: Wait 1 second to catch trailing words
    await Future.delayed(const Duration(seconds: 1));

    if (_isDisposed) return;

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
    if (_isDisposed || !_isListening) return;

    _currentSessionId++;

    // Cooling delay for hardware release
    await Future.delayed(const Duration(milliseconds: 300));

    if (_isDisposed) return;

    if (_isListening) {
      await _listen();
      _safeNotify();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _silenceTimer?.cancel();
    _speechToText.cancel();
    super.dispose();
  }
}
