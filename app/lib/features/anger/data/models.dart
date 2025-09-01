import '../domain/entities.dart';

/// CoachQuestion DTO
class CoachQuestionDto {
  final String category;
  final String questionKey;
  final String type;
  final String textKo;
  final String textEn;
  final List<String> placeholders;
  final Map<String, dynamic> conditions;
  final int cooldownDays;
  final double weight;

  const CoachQuestionDto({
    required this.category,
    required this.questionKey,
    required this.type,
    required this.textKo,
    required this.textEn,
    required this.placeholders,
    required this.conditions,
    required this.cooldownDays,
    required this.weight,
  });

  factory CoachQuestionDto.fromJson(Map<String, dynamic> json) {
    return CoachQuestionDto(
      category: json['category'] as String,
      questionKey: json['questionKey'] as String,
      type: json['type'] as String,
      textKo: json['text_ko'] as String,
      textEn: json['text_en'] as String,
      placeholders: List<String>.from(json['placeholders'] ?? []),
      conditions: Map<String, dynamic>.from(json['conditions'] ?? {}),
      cooldownDays: json['cooldownDays'] as int? ?? 14,
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'questionKey': questionKey,
      'type': type,
      'text_ko': textKo,
      'text_en': textEn,
      'placeholders': placeholders,
      'conditions': conditions,
      'cooldownDays': cooldownDays,
      'weight': weight,
    };
  }

  CoachQuestion toDomain() {
    return CoachQuestion(
      category: category,
      questionKey: questionKey,
      type: type,
      textKo: textKo,
      textEn: textEn,
      placeholders: placeholders,
      conditions: conditions,
      cooldownDays: cooldownDays,
      weight: weight,
    );
  }
}

/// CoachQA DTO
class CoachQADto {
  final String id;
  final String entryId;
  final String category;
  final String questionKey;
  final Map<String, String> promptVars;
  final String? answerText;
  final DateTime createdAt;

  const CoachQADto({
    required this.id,
    required this.entryId,
    required this.category,
    required this.questionKey,
    required this.promptVars,
    this.answerText,
    required this.createdAt,
  });

  factory CoachQADto.fromJson(Map<String, dynamic> json) {
    return CoachQADto(
      id: json['id'] as String,
      entryId: json['entryId'] as String,
      category: json['category'] as String,
      questionKey: json['questionKey'] as String,
      promptVars: Map<String, String>.from(json['promptVars'] ?? {}),
      answerText: json['answerText'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entryId': entryId,
      'category': category,
      'questionKey': questionKey,
      'promptVars': promptVars,
      'answerText': answerText,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CoachQA toDomain() {
    return CoachQA(
      id: id,
      entryId: entryId,
      category: category,
      questionKey: questionKey,
      promptVars: promptVars,
      answerText: answerText,
      createdAt: createdAt,
    );
  }
}

/// AngerEntry DTO
class AngerEntryDto {
  final String id;
  final DateTime createdAt;
  final int intensityBefore;
  final int? intensityAfter;
  final List<String> triggerTags;
  final String? withWhom;
  final String timeOfDay;
  final List<String> techniqueUsed;

  const AngerEntryDto({
    required this.id,
    required this.createdAt,
    required this.intensityBefore,
    this.intensityAfter,
    required this.triggerTags,
    this.withWhom,
    required this.timeOfDay,
    this.techniqueUsed = const [],
  });

  factory AngerEntryDto.fromJson(Map<String, dynamic> json) {
    return AngerEntryDto(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      intensityBefore: json['intensityBefore'] as int,
      intensityAfter: json['intensityAfter'] as int?,
      triggerTags: List<String>.from(json['triggerTags'] ?? []),
      withWhom: json['withWhom'] as String?,
      timeOfDay: json['timeOfDay'] as String,
      techniqueUsed: List<String>.from(json['techniqueUsed'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'intensityBefore': intensityBefore,
      'intensityAfter': intensityAfter,
      'triggerTags': triggerTags,
      'withWhom': withWhom,
      'timeOfDay': timeOfDay,
      'techniqueUsed': techniqueUsed,
    };
  }

  AngerEntry toDomain() {
    return AngerEntry(
      id: id,
      createdAt: createdAt,
      intensityBefore: intensityBefore,
      intensityAfter: intensityAfter,
      triggerTags: triggerTags,
      withWhom: withWhom,
      timeOfDay: timeOfDay,
      techniqueUsed: techniqueUsed,
    );
  }
}

/// 질문 뱅크 JSON 스키마
class QuestionBankSchema {
  final int version;
  final List<String> categories;
  final List<CoachQuestionDto> questions;

  const QuestionBankSchema({
    required this.version,
    required this.categories,
    required this.questions,
  });

  factory QuestionBankSchema.fromJson(Map<String, dynamic> json) {
    return QuestionBankSchema(
      version: json['version'] as int,
      categories: List<String>.from(json['categories'] ?? []),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => CoachQuestionDto.fromJson(q as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'categories': categories,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  /// 스키마 유효성 검사
  bool isValid() {
    return version > 0 && 
           categories.isNotEmpty && 
           questions.isNotEmpty &&
           questions.every((q) => categories.contains(q.category));
  }
}
