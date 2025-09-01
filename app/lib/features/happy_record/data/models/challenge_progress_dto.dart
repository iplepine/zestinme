import '../../domain/models/challenge_progress.dart';

class ChallengeProgressDto {
  final String id;
  final String title;
  final String description;
  final double progress;
  final String todayTask;
  final DateTime startDate;
  final DateTime? endDate;

  ChallengeProgressDto({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.todayTask,
    required this.startDate,
    this.endDate,
  });

  factory ChallengeProgressDto.fromDomain(ChallengeProgress progress) {
    return ChallengeProgressDto(
      id: progress.id,
      title: progress.title,
      description: progress.description,
      progress: progress.progress,
      todayTask: progress.todayTask,
      startDate: progress.startDate,
      endDate: progress.endDate,
    );
  }

  ChallengeProgress toDomain() {
    return ChallengeProgress(
      id: id,
      title: title,
      description: description,
      progress: progress,
      todayTask: todayTask,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

