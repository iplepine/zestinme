import 'package:flutter/material.dart';
import '../../domain/entities.dart';
import '../../data/coach_repository.dart';

/// Deep 모드 코칭 페이지
class DeepCoachPage extends StatefulWidget {
  final List<CoachQuestion> questions;
  final AngerEntry entry;
  final CoachRepository repository;

  const DeepCoachPage({
    super.key,
    required this.questions,
    required this.entry,
    required this.repository,
  });

  @override
  State<DeepCoachPage> createState() => _DeepCoachPageState();
}

class _DeepCoachPageState extends State<DeepCoachPage> {
  late PageController _pageController;
  late List<TextEditingController> _answerControllers;
  late List<String?> _answers;
  int _currentStep = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _answerControllers = List.generate(
      widget.questions.length,
      (index) => TextEditingController(),
    );
    _answers = List.filled(widget.questions.length, null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(_getTitleText(locale.languageCode)),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // 진행률 표시
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 진행률 바
                LinearProgressIndicator(
                  value: (_currentStep + 1) / widget.questions.length,
                  backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 진행률 텍스트
                Text(
                  '${_currentStep + 1} / ${widget.questions.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // 질문 페이지뷰
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                final question = widget.questions[index];
                return _buildQuestionStep(question, index, locale);
              },
            ),
          ),

          // 하단 버튼들
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // 이전 버튼
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goToPreviousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _getPreviousButtonText(locale.languageCode),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                if (_currentStep > 0) const SizedBox(width: 12),

                // 다음/완료 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleNextOrFinish,
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
                            _getNextOrFinishButtonText(locale.languageCode),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 질문 단계 위젯 빌드
  Widget _buildQuestionStep(CoachQuestion question, int index, Locale locale) {
    final theme = Theme.of(context);
    
    // 플레이스홀더가 적용된 질문 텍스트
    String questionText = question.getLocalizedText(locale.languageCode);
    questionText = _applyPlaceholders(questionText, widget.entry);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 칩
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getCategoryColor(question.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getCategoryColor(question.category).withOpacity(0.3),
              ),
            ),
            child: Text(
              question.category,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getCategoryColor(question.category),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 질문 텍스트
          Text(
            questionText,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          // 답변 입력 필드
          TextField(
            controller: _answerControllers[index],
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
              contentPadding: const EdgeInsets.all(20),
            ),
            maxLines: 8,
            onChanged: (value) {
              _answers[index] = value.trim().isEmpty ? null : value.trim();
            },
          ),

          const SizedBox(height: 24),

          // 도움말 텍스트
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getHelpText(locale.languageCode),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 이전 단계로 이동
  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 다음 단계 또는 완료 처리
  void _handleNextOrFinish() async {
    // 현재 답변 저장
    _answers[_currentStep] = _answerControllers[_currentStep].text.trim();
    
    if (_currentStep < widget.questions.length - 1) {
      // 다음 단계로 이동
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 모든 단계 완료 - 답변 저장
      await _saveAllAnswers();
    }
  }

  /// 모든 답변 저장
  Future<void> _saveAllAnswers() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // 각 질문에 대한 QA 저장
      for (int i = 0; i < widget.questions.length; i++) {
        final question = widget.questions[i];
        final answer = _answers[i];
        
        if (answer != null && answer.isNotEmpty) {
          final qa = CoachQA(
            id: '${widget.entry.id}_${question.questionKey}_${DateTime.now().millisecondsSinceEpoch}',
            entryId: widget.entry.id,
            category: question.category,
            questionKey: question.questionKey,
            promptVars: _extractPromptVars(widget.entry),
            answerText: answer,
            createdAt: DateTime.now(),
          );
          
          await widget.repository.saveQA(qa);
        }
      }

      // 완료 후 페이지 닫기
      if (mounted) {
        Navigator.of(context).pop(true); // 완료됨을 알림
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorText(Localizations.localeOf(context).languageCode)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  /// 프롬프트 변수 추출
  Map<String, String> _extractPromptVars(AngerEntry entry) {
    return {
      'trigger': entry.triggerTags.isNotEmpty ? entry.triggerTags.first : '이 상황',
      'withWhom': entry.withWhom ?? '상대방',
      'timeOfDay': entry.timeOfDay,
      'intensity': entry.intensityBefore.toString(),
    };
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

  // 다국어 텍스트 반환 메서드들
  String _getTitleText(String languageCode) {
    return languageCode == 'ko' ? '심화 코칭' : 'Deep Coaching';
  }

  String _getPreviousButtonText(String languageCode) {
    return languageCode == 'ko' ? '이전' : 'Previous';
  }

  String _getNextOrFinishButtonText(String languageCode) {
    return languageCode == 'ko' ? '완료' : 'Finish';
  }

  String _getHintText(String languageCode) {
    return languageCode == 'ko' 
        ? '자세한 답변을 입력해주세요...' 
        : 'Type your detailed answer...';
  }

  String _getHelpText(String languageCode) {
    return languageCode == 'ko' 
        ? '마음껏 표현해보세요. 정답은 없습니다.' 
        : 'Express yourself freely. There are no right answers.';
  }

  String _getErrorText(String languageCode) {
    return languageCode == 'ko' 
        ? '저장 중 오류가 발생했습니다.' 
        : 'An error occurred while saving.';
  }
}
