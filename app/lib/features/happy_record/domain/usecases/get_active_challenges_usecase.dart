import '../models/challenge_progress.dart';
import '../repositories/challenge_repository.dart';

class GetActiveChallengesUseCase {
  final ChallengeRepository _challengeRepository;

  GetActiveChallengesUseCase(this._challengeRepository);

  List<ChallengeProgress> execute() {
    return _challengeRepository.getActiveChallenges();
  }
}

