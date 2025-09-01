import '../../domain/models/challenge.dart';

class ChallengeDto {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String difficulty;
  final int participants;
  final String emoji;
  final int durationDays;

  ChallengeDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.participants,
    required this.emoji,
    required this.durationDays,
  });

  factory ChallengeDto.fromDomain(Challenge challenge) {
    return ChallengeDto(
      id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      category: challenge.category,
      duration: challenge.duration,
      difficulty: challenge.difficulty,
      participants: challenge.participants,
      emoji: challenge.emoji,
      durationDays: challenge.durationDays,
    );
  }

  Challenge toDomain() {
    return Challenge(
      id: id,
      title: title,
      description: description,
      category: category,
      duration: duration,
      difficulty: difficulty,
      participants: participants,
      emoji: emoji,
      durationDays: durationDays,
    );
  }
}
