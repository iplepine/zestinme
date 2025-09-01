import '../models/challenge.dart';
import '../models/challenge_progress.dart';
import '../models/completed_challenge.dart';

abstract class ChallengeRepository {
  // 사용 가능한 챌린지 목록 조회
  List<Challenge> getAvailableChallenges();

  // 진행 중인 챌린지 목록 조회
  List<ChallengeProgress> getActiveChallenges();

  // 완료된 챌린지 목록 조회
  List<CompletedChallenge> getCompletedChallenges();

  // 챌린지 시작
  Future<void> startChallenge(String challengeId);

  // 챌린지 진행도 업데이트
  Future<void> updateChallengeProgress(String challengeId, double progress);

  // 챌린지 완료
  Future<void> completeChallenge(
    String challengeId,
    String result,
    double completionRate,
  );

  // 챌린지 포기
  Future<void> abandonChallenge(String challengeId);
}

