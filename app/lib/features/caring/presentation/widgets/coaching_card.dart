import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import 'dart:math';

class CoachingCard extends StatefulWidget {
  final String question;
  final VoidCallback onAnswerSubmitted;
  final ValueChanged<String> onAnswerChanged;
  final String submitLabel;
  final IconData submitIcon;

  const CoachingCard({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onAnswerChanged,
    this.submitLabel = "가치 발견",
    this.submitIcon = Icons.auto_awesome,
  });

  @override
  State<CoachingCard> createState() => _CoachingCardState();
}

class _CoachingCardState extends State<CoachingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

  bool _isFront = true;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _frontRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: pi / 2), weight: 50),
      TweenSequenceItem(tween: ConstantTween(pi / 2), weight: 50),
    ]).animate(_controller);

    _backRotation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(-pi / 2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -pi / 2, end: 0.0), weight: 50),
    ]).animate(_controller);
  }

  // NOTE: Logic to update text controller if question changes (for parent rebuilds)
  @override
  void didUpdateWidget(CoachingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question != oldWidget.question) {
      // If question changed (new stage), reset card to front and clear text?
      // For now, let parent handle state reset.
      // But we should clear the text controller if the parent says so,
      // however parent clears the _answer string but text controller has its own state.
      // Ideally parent passes initialValue.
      // We will just clear it if the question is different, assuming new question = empty answer.
      _textController.clear();
      if (!_isFront) {
        // Force flip back to front instantly or animate?
        // Let's animate back to front to show new question.
        _flipCard();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Back Card (Answer Input)
          AnimatedBuilder(
            animation: _backRotation,
            builder: (context, child) {
              final angle = _backRotation.value;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: angle >= pi / 2 || angle <= -pi / 2
                    ? const SizedBox.shrink()
                    : _buildBack(),
              );
            },
          ),
          // Front Card (Question)
          AnimatedBuilder(
            animation: _frontRotation,
            builder: (context, child) {
              final angle = _frontRotation.value;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: angle >= pi / 2
                    ? const SizedBox.shrink()
                    : _buildFront(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFront() {
    return GestureDetector(
      onTap: _flipCard,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar / Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology, color: AppTheme.primaryColor),
            ),
            const Spacer(),
            // Question
            Text(
              widget.question,
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // Hint
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "탭하여 답변 남기기",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.touch_app,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3), // Active border
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onChanged: widget.onAnswerChanged,
              maxLines: null,
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: "솔직하게 적어보세요...",
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                filled: false, // Transparent background for simpler look
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Push buttons to right/edges
            children: [
              TextButton(
                onPressed: _flipCard,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  foregroundColor: Colors.white.withValues(alpha: 0.6),
                ),
                child: const Text("뒤로"),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: widget.onAnswerSubmitted,
                icon: Icon(widget.submitIcon, size: 18),
                label: Text(widget.submitLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
