import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import '../domain/entities.dart';

/// 질문 뱅크를 로드하는 클래스
class QuestionBankLoader {
  static const String _fallbackAssetPath = 'assets/question_bank_fallback.json';
  static const String _remoteConfigKey = 'question_bank_json';
  static const String _firestorePath = 'config/question_bank';
  static const String _firestoreField = 'bankJson';

  final FirebaseRemoteConfig _remoteConfig;
  final FirebaseFirestore _firestore;

  QuestionBankLoader({
    required FirebaseRemoteConfig remoteConfig,
    required FirebaseFirestore firestore,
  }) : _remoteConfig = remoteConfig,
       _firestore = firestore;

  /// 질문들을 우선순위에 따라 로드
  Future<List<CoachQuestion>> loadQuestions() async {
    try {
      // 1. Remote Config에서 로드 시도
      final remoteConfigQuestions = await _loadFromRemoteConfig();
      if (remoteConfigQuestions.isNotEmpty) {
        return remoteConfigQuestions;
      }

      // 2. Firestore에서 로드 시도
      final firestoreQuestions = await _loadFromFirestore();
      if (firestoreQuestions.isNotEmpty) {
        return firestoreQuestions;
      }

      // 3. 로컬 에셋에서 로드 (fallback)
      return await _loadFromAsset();
    } catch (e) {
      // 모든 로드 실패 시 fallback 에셋 사용
      return await _loadFromAsset();
    }
  }

  /// Remote Config에서 질문 로드
  Future<List<CoachQuestion>> _loadFromRemoteConfig() async {
    try {
      await _remoteConfig.fetchAndActivate();
      final jsonString = _remoteConfig.getString(_remoteConfigKey);

      if (jsonString.isEmpty) return [];

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final schema = QuestionBankSchema.fromJson(json);

      if (schema.isValid()) {
        return schema.questions.map((q) => q.toDomain()).toList();
      }
    } catch (e) {
      // Remote Config 로드 실패 시 빈 리스트 반환
    }
    return [];
  }

  /// Firestore에서 질문 로드
  Future<List<CoachQuestion>> _loadFromFirestore() async {
    try {
      final doc = await _firestore.doc(_firestorePath).get();
      if (!doc.exists) return [];

      final data = doc.data();
      if (data == null || !data.containsKey(_firestoreField)) return [];

      final jsonString = data![_firestoreField] as String;
      if (jsonString.isEmpty) return [];

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final schema = QuestionBankSchema.fromJson(json);

      if (schema.isValid()) {
        return schema.questions.map((q) => q.toDomain()).toList();
      }
    } catch (e) {
      // Firestore 로드 실패 시 빈 리스트 반환
    }
    return [];
  }

  /// 로컬 에셋에서 질문 로드 (fallback)
  Future<List<CoachQuestion>> _loadFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(_fallbackAssetPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final schema = QuestionBankSchema.fromJson(json);

      if (schema.isValid()) {
        return schema.questions.map((q) => q.toDomain()).toList();
      }
    } catch (e) {
      // 에셋 로드 실패 시 기본 질문들 반환
      return _getDefaultQuestions();
    }
    return _getDefaultQuestions();
  }

  /// 기본 질문들 (에셋 로드 실패 시 사용)
  List<CoachQuestion> _getDefaultQuestions() {
    return [
      CoachQuestion(
        category: 'Calm',
        questionKey: 'calm.body_signal.v1',
        type: 'quick',
        textKo: '지금 몸에서 가장 강한 신호는 하나만 고르세요.',
        textEn: 'Pick the strongest body signal right now.',
        placeholders: [],
        conditions: {'minIntensity': 7},
        cooldownDays: 14,
        weight: 1.0,
      ),
      CoachQuestion(
        category: 'Boundaries',
        questionKey: 'boundaries.assertive_sentence.v1',
        type: 'deep',
        textKo: '예의 있게 단호한 한 문장을 만들어보세요.',
        textEn: 'Write one polite, assertive sentence.',
        placeholders: [],
        conditions: {
          'tagsAny': ['work_meeting'],
        },
        cooldownDays: 14,
        weight: 1.0,
      ),
      CoachQuestion(
        category: 'Plan',
        questionKey: 'plan.if_then_when.v1',
        type: 'quick',
        textKo: '만약 {trigger}라면, 즉시 무엇을 하시겠어요? 한 문장으로.',
        textEn: 'If {trigger}, what will you do immediately? One sentence.',
        placeholders: ['trigger'],
        conditions: {},
        cooldownDays: 7,
        weight: 1.2,
      ),
    ];
  }
}
