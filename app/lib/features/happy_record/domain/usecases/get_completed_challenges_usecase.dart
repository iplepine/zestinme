import '../models/completed_challenge.dart';
import '../repositories/challenge_repository.dart';

class GetCompletedChallengesUseCase {
  final ChallengeRepository _challengeRepository;

  GetCompletedChallengesUseCase(this._challengeRepository);

  List<CompletedChallenge> execute() {
    return _challengeRepository.getCompletedChallenges();
  }
}
