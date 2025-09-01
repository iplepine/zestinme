import 'package:flutter/material.dart';
import '../../../di/injection.dart';
import '../../../core/services/firebase_service.dart';
import '../data/question_bank_loader.dart';
import '../data/coach_repository.dart';
import '../domain/entities.dart';

/// Firebase 연결 테스트 페이지
class TestFirebasePage extends StatefulWidget {
  const TestFirebasePage({super.key});

  @override
  State<TestFirebasePage> createState() => _TestFirebasePageState();
}

class _TestFirebasePageState extends State<TestFirebasePage> {
  bool _isLoading = false;
  String _status = '테스트를 시작하세요';
  List<String> _logs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase 연결 테스트'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 테스트 버튼들
            ElevatedButton(
              onPressed: _isLoading ? null : _testFirebaseConnection,
              child: const Text('Firebase 연결 테스트'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testQuestionBankLoader,
              child: const Text('질문 뱅크 로더 테스트'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testCoachRepository,
              child: const Text('코칭 Repository 테스트'),
            ),
            const SizedBox(height: 16),

            // 상태 표시
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Text(
                _status,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 16),

            // 로그 표시
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '테스트 로그:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              _logs[index],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Firebase 연결 테스트
  Future<void> _testFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Firebase 연결 테스트 중...';
      _logs.clear();
    });

    try {
      _addLog('Firebase 서비스 초기화 확인...');
      final firebaseService = Injection.getIt<FirebaseService>();

      if (firebaseService.isInitialized) {
        _addLog('✅ Firebase 서비스가 초기화되었습니다.');
      } else {
        _addLog('❌ Firebase 서비스가 초기화되지 않았습니다.');
        return;
      }

      _addLog('Firebase 연결 상태 확인...');
      final isConnected = await firebaseService.checkConnection();

      if (isConnected) {
        _addLog('✅ Firebase에 성공적으로 연결되었습니다.');
        _status = 'Firebase 연결 성공!';
      } else {
        _addLog('❌ Firebase 연결에 실패했습니다.');
        _status = 'Firebase 연결 실패';
      }
    } catch (e) {
      _addLog('❌ Firebase 연결 테스트 중 오류 발생: $e');
      _status = '오류 발생: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 질문 뱅크 로더 테스트
  Future<void> _testQuestionBankLoader() async {
    setState(() {
      _isLoading = true;
      _status = '질문 뱅크 로더 테스트 중...';
      _logs.clear();
    });

    try {
      _addLog('질문 뱅크 로더 가져오기...');
      final loader = Injection.getIt<QuestionBankLoader>();
      _addLog('✅ 질문 뱅크 로더를 성공적으로 가져왔습니다.');

      _addLog('질문 로드 시도...');
      final questions = await loader.loadQuestions();

      if (questions.isNotEmpty) {
        _addLog('✅ ${questions.length}개의 질문을 성공적으로 로드했습니다.');
        _addLog(
          '첫 번째 질문: ${questions.first.category} - ${questions.first.questionKey}',
        );
        _status = '질문 뱅크 로더 테스트 성공!';
      } else {
        _addLog('⚠️ 질문이 로드되지 않았습니다. (fallback 데이터 사용)');
        _status = '질문 뱅크 로더 테스트 완료 (fallback)';
      }
    } catch (e) {
      _addLog('❌ 질문 뱅크 로더 테스트 중 오류 발생: $e');
      _status = '오류 발생: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 코칭 Repository 테스트
  Future<void> _testCoachRepository() async {
    setState(() {
      _isLoading = true;
      _status = '코칭 Repository 테스트 중...';
      _logs.clear();
    });

    try {
      _addLog('코칭 Repository 가져오기...');
      final repository = Injection.getIt<CoachRepository>();
      _addLog('✅ 코칭 Repository를 성공적으로 가져왔습니다.');

      _addLog('최근 QA 조회 테스트...');
      final recentQAs = await repository.recentQAs(days: 7);
      _addLog('✅ 최근 QA 조회 성공: ${recentQAs.length}개');

      _addLog('효과 점수 로드 테스트...');
      final effectScores = await repository.loadEffectScores();
      _addLog('✅ 효과 점수 로드 성공');
      _addLog('카테고리 점수: ${effectScores.byCategory.length}개');
      _addLog('질문 키 점수: ${effectScores.byQuestionKey.length}개');

      _status = '코칭 Repository 테스트 성공!';
    } catch (e) {
      _addLog('❌ 코칭 Repository 테스트 중 오류 발생: $e');
      _status = '오류 발생: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 로그 추가
  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.add('[$timestamp] $message');
    });
  }
}
