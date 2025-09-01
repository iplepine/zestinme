import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities.dart';
import 'models.dart';

/// 코칭 관련 데이터를 관리하는 repository
class CoachRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  CoachRepository({
    required FirebaseFirestore firestore,
    required String userId,
  }) : _firestore = firestore,
       _userId = userId;

  /// QA 저장
  Future<void> saveQA(CoachQA qa) async {
    try {
      final qaDto = CoachQADto(
        id: qa.id,
        entryId: qa.entryId,
        category: qa.category,
        questionKey: qa.questionKey,
        promptVars: qa.promptVars,
        answerText: qa.answerText,
        createdAt: qa.createdAt,
      );

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('coach_qas')
          .doc(qa.id)
          .set(qaDto.toJson());
    } catch (e) {
      // 에러 처리 (로깅, 재시도 등)
      rethrow;
    }
  }

  /// 최근 QA 목록 조회
  Future<List<CoachQA>> recentQAs({int days = 14}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final querySnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('coach_qas')
          .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoffDate))
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CoachQADto.fromJson(doc.data()).toDomain())
          .toList();
    } catch (e) {
      // 에러 처리
      return [];
    }
  }

  /// 효과 점수 로드 (과거 30일 데이터 기반)
  Future<UserEffectScore> loadEffectScores() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

      // 최근 30일간의 QA와 분노 기록을 가져와서 효과 점수 계산
      final qas = await recentQAs(days: 30);

      // 분노 기록도 가져오기
      final angerEntries = await _getRecentAngerEntries(cutoffDate);

      return _calculateEffectScores(qas, angerEntries);
    } catch (e) {
      // 에러 시 기본 점수 반환
      return const UserEffectScore(byCategory: {}, byQuestionKey: {});
    }
  }

  /// 최근 분노 기록 조회
  Future<List<AngerEntry>> _getRecentAngerEntries(DateTime cutoffDate) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('anger_entries')
          .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoffDate))
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AngerEntryDto.fromJson(doc.data()).toDomain())
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 효과 점수 계산
  UserEffectScore _calculateEffectScores(
    List<CoachQA> qas,
    List<AngerEntry> angerEntries,
  ) {
    final categoryScores = <String, double>{};
    final questionKeyScores = <String, double>{};

    // 각 QA에 대해 효과 점수 계산
    for (final qa in qas) {
      // 해당 QA와 연관된 분노 기록 찾기
      final relatedEntry = angerEntries
          .where((entry) => entry.id == qa.entryId)
          .firstOrNull;

      if (relatedEntry != null && relatedEntry.intensityDelta != null) {
        // 강도 변화가 있으면 효과 점수 계산
        final effect = _calculateQuestionEffect(relatedEntry, qa);

        // 카테고리별 점수 누적
        categoryScores[qa.category] =
            (categoryScores[qa.category] ?? 1.0) + effect;

        // 질문 키별 점수 누적
        questionKeyScores[qa.questionKey] =
            (questionKeyScores[qa.questionKey] ?? 1.0) + effect;
      }
    }

    return UserEffectScore(
      byCategory: categoryScores,
      byQuestionKey: questionKeyScores,
    );
  }

  /// 개별 질문의 효과 점수 계산
  double _calculateQuestionEffect(AngerEntry entry, CoachQA qa) {
    if (entry.intensityDelta == null) return 0.0;

    // 강도가 낮아졌으면 양수 점수, 높아졌으면 음수 점수
    final baseEffect = entry.intensityDelta! < 0 ? 0.1 : -0.05;

    // 답변이 있으면 추가 점수
    if (qa.answerText != null && qa.answerText!.isNotEmpty) {
      return baseEffect + 0.05;
    }

    return baseEffect;
  }
}
