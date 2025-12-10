import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';

class RollingHintTextField extends StatefulWidget {
  final AppLocalizations l10n;
  final ValueChanged<String> onChanged;

  const RollingHintTextField({
    super.key,
    required this.l10n,
    required this.onChanged,
  });

  @override
  State<RollingHintTextField> createState() => _RollingHintTextFieldState();
}

class _RollingHintTextFieldState extends State<RollingHintTextField> {
  late List<String> _hints;
  int _currentHintIndex = 0;
  Timer? _timer;
  final TextEditingController _controller = TextEditingController();
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _hints = [
      widget.l10n.seeding_hint_trigger,
      widget.l10n.seeding_hint_thought,
      widget.l10n.seeding_hint_tendency,
    ];
    _startTimer();
    _controller.addListener(_handleInput);
  }

  void _handleInput() {
    setState(() {
      _hasInput = _controller.text.isNotEmpty;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_hasInput) return;
      if (!mounted) return;
      setState(() {
        _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _hasInput
              ? const SizedBox(height: 24)
              : Row(
                  key: ValueKey(_currentHintIndex),
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hints[_currentHintIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          style: const TextStyle(color: Colors.white),
          maxLength: 300,
          maxLines: 2,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            counterText: "",
          ),
        ),
      ],
    );
  }
}
