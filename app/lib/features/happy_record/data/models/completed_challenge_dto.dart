import '../../domain/models/completed_challenge.dart';

class CompletedChallengeDto {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime completionDate;
  final String result;
  final double completionRate;

  CompletedChallengeDto({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.completionDate,
    required this.result,
    required this.completionRate,
  });

  factory CompletedChallengeDto.fromDomain(CompletedChallenge challenge) {
    return CompletedChallengeDto(
      id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      startDate: challenge.startDate,
      completionDate: challenge.completionDate,
      result: challenge.result,
      completionRate: challenge.completionRate,
    );
  }

  CompletedChallenge toDomain() {
    return CompletedChallenge(
      id: id,
      title: title,
      description: description,
      startDate: startDate,
      completionDate: completionDate,
      result: result,
      completionRate: completionRate,
    );
  }
}

