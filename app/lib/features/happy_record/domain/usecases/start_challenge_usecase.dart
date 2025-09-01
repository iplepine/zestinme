import '../repositories/challenge_repository.dart';

class StartChallengeUseCase {
  final ChallengeRepository _challengeRepository;

  StartChallengeUseCase(this._challengeRepository);

  Future<void> execute(String challengeId) async {
    await _challengeRepository.startChallenge(challengeId);
  }
}

