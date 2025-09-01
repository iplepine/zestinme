import '../models/challenge.dart';
import '../models/challenge_progress.dart';
import '../repositories/challenge_repository.dart';

class ChallengeExploreItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String difficulty;
  final int participants;
  final String emoji;

  ChallengeExploreItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.participants,
    required this.emoji,
  });

  factory ChallengeExploreItem.fromChallenge(Challenge challenge) {
    return ChallengeExploreItem(
      id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      category: challenge.category,
      duration: challenge.duration,
      difficulty: challenge.difficulty,
      participants: challenge.participants,
      emoji: challenge.emoji,
    );
  }
}

class GetAvailableChallengesUseCase {
  final ChallengeRepository _challengeRepository;

  GetAvailableChallengesUseCase(this._challengeRepository);

  /// 현재 진행 중인 챌린지를 제외한 사용 가능한 챌린지 목록을 반환합니다.
  List<ChallengeExploreItem> execute() {
    final availableChallenges = _challengeRepository.getAvailableChallenges();

    return availableChallenges
        .map((challenge) => ChallengeExploreItem.fromChallenge(challenge))
        .toList();
  }
}
