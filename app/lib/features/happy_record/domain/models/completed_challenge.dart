class CompletedChallenge {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime completionDate;
  final String result; // '성공', '부분 성공', '실패'
  final double completionRate; // 0.0 ~ 1.0

  CompletedChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.completionDate,
    required this.result,
    required this.completionRate,
  });
}

