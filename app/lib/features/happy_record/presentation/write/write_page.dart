import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/record.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../di/injection.dart';
import '../../domain/usecases/add_record_usecase.dart';
import 'widgets/date_time_selection_widget.dart';
import 'widgets/emotion_selection_widget.dart';

/// 행복한 순간 작성 화면 (MVP)
class WritePage extends StatefulWidget {
  final int? initialScore;
  const WritePage({super.key, this.initialScore});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _scrollController = ScrollController();
  int _selectedEmotion = -1;
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 진입 후 바로 포커스 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });

    _contentFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.removeListener(_onFocusChange);
    _contentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_contentFocusNode.hasFocus) {
      // 키보드가 올라오는 시간을 고려하여 약간의 지연 후 스크롤
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _scrollController.hasClients) {
          final targetOffset =
              (_scrollController.position.maxScrollExtent - 100).clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              );

          _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final record = Record(
          id: UniqueKey().toString(),
          content: _contentController.text,
          intensity: _selectedEmotion >= 0 ? _selectedEmotion + 1 : 3,
          tags: const [],
          createdAt: _selectedDateTime,
          location: null,
          photos: const [],
        );

        // UseCase를 통한 저장 - 안전한 방식으로 호출
        if (Injection.getIt.isRegistered<AddRecordUseCase>()) {
          final addRecordUseCase = Injection.getIt<AddRecordUseCase>();
          await addRecordUseCase(record);
        } else {
          // 의존성 주입이 안 된 경우를 위한 fallback
          print('AddRecordUseCase가 등록되지 않았습니다.');
          // 여기서는 단순히 화면을 닫기만 함
        }

        // async 처리 후 context 사용 시 mounted 체크
        if (mounted) {
          // GoRouter를 사용하므로 context.pop 사용
          context.pop(true);
        }
      } catch (e) {
        print('저장 중 오류 발생: $e');
        // 에러가 발생해도 화면은 닫기
        if (mounted) {
          context.pop(false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('감정 기록'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // 날짜/시간 선택 섹션
                DateTimeSelectionWidget(
                  selectedDateTime: _selectedDateTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedDateTime = newDateTime;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // 경험 기록 섹션
                Text(
                  '좋았던 경험을 한 줄로 적어보세요',
                  style: TextStyle(
                    color: AppColors.foreground,
                    fontSize: 16,
                    fontWeight: AppColors.fontWeightMedium,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '예: 동료가 내 아이디어를 칭찬해주었다',
                    hintStyle: TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.primary.withValues(alpha: 0.1),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '경험을 입력하세요' : null,
                ),
                const SizedBox(height: 16),

                // 감정 선택 섹션
                EmotionSelectionWidget(
                  selectedEmotion: _selectedEmotion,
                  onEmotionSelected: (int emotionIndex) {
                    setState(() {
                      _selectedEmotion = emotionIndex;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // 저장 버튼
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: AppColors.fontWeightMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
