import 'package:flutter/material.dart';
import '../../domain/entities.dart';

/// Quick 모드 코칭 카드 위젯
class QuickCoachCard extends StatefulWidget {
  final CoachQuestion question;
  final void Function(String answer) onSubmit;
  final VoidCallback onSnooze;
  final VoidCallback onSkip;
  final AngerEntry? entry; // 플레이스홀더 적용을 위해 필요

  const QuickCoachCard({
    super.key,
    required this.question,
    required this.onSubmit,
    required this.onSnooze,
    required this.onSkip,
    this.entry,
  });

  @override
  State<QuickCoachCard> createState() => _QuickCoachCardState();
}

class _QuickCoachCardState extends State<QuickCoachCard> {
  final TextEditingController _answerController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    
    // 플레이스홀더가 적용된 질문 텍스트
    String questionText = widget.question.getLocalizedText(locale.languageCode);
    if (widget.entry != null) {
      questionText = _applyPlaceholders(questionText, widget.entry!);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              // 카테고리 칩
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(widget.question.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getCategoryColor(widget.question.category).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  widget.question.category,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getCategoryColor(widget.question.category),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onSkip,
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 질문 텍스트
          Text(
            questionText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          // 답변 입력 필드
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              hintText: _getHintText(locale.languageCode),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
          ),

          const SizedBox(height: 24),

          // 액션 버튼들
          Row(
            children: [
              // 지금 답변하기
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _getSubmitButtonText(locale.languageCode),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // 오늘 밤에
              OutlinedButton(
                onPressed: widget.onSnooze,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getSnoozeButtonText(locale.languageCode),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 건너뛰기 버튼
          Center(
            child: TextButton(
              onPressed: widget.onSkip,
              child: Text(
                _getSkipButtonText(locale.languageCode),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 제출 처리
  void _handleSubmit() {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      widget.onSubmit(answer);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  /// 플레이스홀더 적용
  String _applyPlaceholders(String text, AngerEntry entry) {
    var result = text;
    
    // {trigger} 플레이스홀더
    if (result.contains('{trigger}')) {
      final trigger = entry.triggerTags.isNotEmpty 
          ? entry.triggerTags.first 
          : '이 상황';
      result = result.replaceAll('{trigger}', trigger);
    }
    
    // {withWhom} 플레이스홀더
    if (result.contains('{withWhom}')) {
      final withWhom = entry.withWhom ?? '상대방';
      result = result.replaceAll('{withWhom}', withWhom);
    }
    
    return result;
  }

  /// 카테고리별 색상 반환
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Calm':
        return Colors.blue;
      case 'Reappraise':
        return Colors.green;
      case 'Needs':
        return Colors.orange;
      case 'Boundaries':
        return Colors.red;
      case 'Pattern':
        return Colors.purple;
      case 'Plan':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// 힌트 텍스트 반환
  String _getHintText(String languageCode) {
    return languageCode == 'ko' 
        ? '답변을 입력해주세요...' 
        : 'Type your answer...';
  }

  /// 제출 버튼 텍스트 반환
  String _getSubmitButtonText(String languageCode) {
    return languageCode == 'ko' ? '지금 답변하기' : 'Answer now';
  }

  /// 스누즈 버튼 텍스트 반환
  String _getSnoozeButtonText(String languageCode) {
    return languageCode == 'ko' ? '오늘 밤에' : 'Tonight';
  }

  /// 건너뛰기 버튼 텍스트 반환
  String _getSkipButtonText(String languageCode) {
    return languageCode == 'ko' ? '건너뛰기' : 'Skip';
  }
}
