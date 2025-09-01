import 'package:hive/hive.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../../domain/models/challenge.dart';
import '../../domain/models/challenge_progress.dart';
import '../../domain/models/completed_challenge.dart';
import '../models/challenge_dto.dart';
import '../models/challenge_progress_dto.dart';
import '../models/completed_challenge_dto.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final Box<ChallengeDto> _challengeBox;
  final Box<ChallengeProgressDto> _progressBox;
  final Box<CompletedChallengeDto> _completedBox;

  ChallengeRepositoryImpl({
    required Box<ChallengeDto> challengeBox,
    required Box<ChallengeProgressDto> progressBox,
    required Box<CompletedChallengeDto> completedBox,
  }) : _challengeBox = challengeBox,
       _progressBox = progressBox,
       _completedBox = completedBox;

  @override
  List<Challenge> getAvailableChallenges() {
    // 초기 데이터가 없으면 기본 챌린지들을 생성
    if (_challengeBox.isEmpty) {
      _initializeDefaultChallenges();
    }

    final challenges = _challengeBox.values
        .map((dto) => dto.toDomain())
        .toList();

    // 현재 진행 중인 챌린지들을 제외
    final activeChallengeTitles = getActiveChallenges()
        .map((progress) => progress.title)
        .toList();

    return challenges
        .where((challenge) => !activeChallengeTitles.contains(challenge.title))
        .toList();
  }

  @override
  List<ChallengeProgress> getActiveChallenges() {
    return _progressBox.values.map((dto) => dto.toDomain()).toList();
  }

  @override
  List<CompletedChallenge> getCompletedChallenges() {
    return _completedBox.values.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> startChallenge(String challengeId) async {
    final challenge = _challengeBox.values
        .firstWhere((dto) => dto.id == challengeId)
        .toDomain();

    final progress = ChallengeProgress(
      id: challengeId,
      title: challenge.title,
      description: challenge.description,
      progress: 0.0,
      todayTask: _getTodayTask(challenge),
      startDate: DateTime.now(),
    );

    final progressDto = ChallengeProgressDto.fromDomain(progress);
    await _progressBox.add(progressDto);
  }

  @override
  Future<void> updateChallengeProgress(
    String challengeId,
    double progress,
  ) async {
    final progressKey = _progressBox.keys.firstWhere(
      (key) => _progressBox.get(key)?.id == challengeId,
    );

    final currentProgress = _progressBox.get(progressKey)!.toDomain();
    final updatedProgress = ChallengeProgress(
      id: currentProgress.id,
      title: currentProgress.title,
      description: currentProgress.description,
      progress: progress,
      todayTask: currentProgress.todayTask,
      startDate: currentProgress.startDate,
      endDate: currentProgress.endDate,
    );

    await _progressBox.put(
      progressKey,
      ChallengeProgressDto.fromDomain(updatedProgress),
    );
  }

  @override
  Future<void> completeChallenge(
    String challengeId,
    String result,
    double completionRate,
  ) async {
    final progressKey = _progressBox.keys.firstWhere(
      (key) => _progressBox.get(key)?.id == challengeId,
    );
    final progress = _progressBox.get(progressKey)!.toDomain();

    // 완료된 챌린지로 이동
    final completedChallenge = CompletedChallenge(
      id: progress.id,
      title: progress.title,
      description: progress.description,
      startDate: progress.startDate,
      completionDate: DateTime.now(),
      result: result,
      completionRate: completionRate,
    );

    await _completedBox.add(
      CompletedChallengeDto.fromDomain(completedChallenge),
    );
    await _progressBox.delete(progressKey);
  }

  @override
  Future<void> abandonChallenge(String challengeId) async {
    final progressKey = _progressBox.keys.firstWhere(
      (key) => _progressBox.get(key)?.id == challengeId,
    );
    await _progressBox.delete(progressKey);
  }

  void _initializeDefaultChallenges() {
    final defaultChallenges = [
      Challenge(
        id: '1',
        title: '매일 감정 기록하기',
        description: '30일 동안 매일 감정을 기록하는 챌린지',
        category: '감정 관리',
        duration: '30일',
        difficulty: '쉬움',
        participants: 1250,
        emoji: '📝',
        durationDays: 30,
      ),
      Challenge(
        id: '2',
        title: '감사 일기 쓰기',
        description: '매일 감사한 일 3가지를 기록하기',
        category: '습관 형성',
        duration: '21일',
        difficulty: '보통',
        participants: 890,
        emoji: '🙏',
        durationDays: 21,
      ),
      Challenge(
        id: '3',
        title: '긍정적 사고 연습',
        description: '부정적인 상황에서 긍정적 관점 찾기',
        category: '자기계발',
        duration: '14일',
        difficulty: '어려움',
        participants: 567,
        emoji: '✨',
        durationDays: 14,
      ),
      Challenge(
        id: '4',
        title: '스트레스 해소 루틴',
        description: '매일 10분 명상으로 스트레스 관리하기',
        category: '건강',
        duration: '21일',
        difficulty: '보통',
        participants: 1200,
        emoji: '🧘‍♀️',
        durationDays: 21,
      ),
      Challenge(
        id: '5',
        title: '친구와 연락하기',
        description: '주 3회 이상 친구와 연락하고 대화하기',
        category: '관계',
        duration: '30일',
        difficulty: '쉬움',
        participants: 750,
        emoji: '💬',
        durationDays: 30,
      ),
      Challenge(
        id: '6',
        title: '독서 습관 만들기',
        description: '매일 30분씩 책 읽기',
        category: '자기계발',
        duration: '21일',
        difficulty: '보통',
        participants: 680,
        emoji: '📚',
        durationDays: 21,
      ),
      Challenge(
        id: '7',
        title: '운동 습관 만들기',
        description: '주 3회 이상 운동하기',
        category: '건강',
        duration: '30일',
        difficulty: '보통',
        participants: 950,
        emoji: '💪',
        durationDays: 30,
      ),
      Challenge(
        id: '8',
        title: '창의력 발달',
        description: '매일 새로운 아이디어 생각해보기',
        category: '자기계발',
        duration: '14일',
        difficulty: '어려움',
        participants: 320,
        emoji: '💡',
        durationDays: 14,
      ),
      Challenge(
        id: '9',
        title: '시간 관리 연습',
        description: '매일 할 일을 계획하고 실행하기',
        category: '습관 형성',
        duration: '21일',
        difficulty: '보통',
        participants: 450,
        emoji: '⏰',
        durationDays: 21,
      ),
      Challenge(
        id: '10',
        title: '감정 표현 연습',
        description: '매일 감정을 자유롭게 표현해보기',
        category: '감정 관리',
        duration: '14일',
        difficulty: '보통',
        participants: 380,
        emoji: '😊',
        durationDays: 14,
      ),
    ];

    for (final challenge in defaultChallenges) {
      _challengeBox.add(ChallengeDto.fromDomain(challenge));
    }
  }

  String _getTodayTask(Challenge challenge) {
    switch (challenge.title) {
      case '매일 감정 기록하기':
        return '오늘의 감정을 기록해보세요';
      case '감사 일기 쓰기':
        return '오늘 감사한 일을 찾아보세요';
      case '긍정적 사고 연습':
        return '어려운 상황에서 긍정적 면을 찾아보세요';
      case '스트레스 해소 루틴':
        return '오늘 10분 명상을 해보세요';
      case '친구와 연락하기':
        return '친구에게 연락해보세요';
      case '독서 습관 만들기':
        return '오늘 30분 책을 읽어보세요';
      case '운동 습관 만들기':
        return '오늘 운동을 해보세요';
      case '창의력 발달':
        return '새로운 아이디어를 생각해보세요';
      case '시간 관리 연습':
        return '오늘 할 일을 계획해보세요';
      case '감정 표현 연습':
        return '오늘 감정을 자유롭게 표현해보세요';
      default:
        return '오늘의 챌린지를 수행해보세요';
    }
  }
}

