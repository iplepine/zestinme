import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../firebase_options.dart';

/// Firebase 서비스를 관리하는 클래스
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  late FirebaseFirestore _firestore;
  late FirebaseRemoteConfig _remoteConfig;
  bool _isInitialized = false;

  /// Firebase 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Firebase Core 초기화
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Firestore 초기화
      _firestore = FirebaseFirestore.instance;

      // Remote Config 초기화
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          // 개발 모드에서는 즉시 반영을 위해 0으로 설정, 운영에서는 1시간 등으로 유지 권장
          minimumFetchInterval: Duration.zero,
        ),
      );

      // 기본값 설정
      await _remoteConfig.setDefaults({'question_bank_json': ''});

      // 원격 설정 가져오기 (실패해도 앱 시작은 가능하도록 처리)
      try {
        await _remoteConfig.fetchAndActivate();
      } catch (e) {
        print('Firebase Remote Config fetch failed: $e');
        // 실패하더라도 기본값(setDefaults)을 사용하므로 초기화는 계속 진행
      }

      _isInitialized = true;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
      rethrow;
    }
  }

  /// Firestore 인스턴스 반환
  FirebaseFirestore get firestore {
    if (!_isInitialized) {
      throw StateError('Firebase is not initialized. Call initialize() first.');
    }
    return _firestore;
  }

  /// Remote Config 인스턴스 반환
  FirebaseRemoteConfig get remoteConfig {
    if (!_isInitialized) {
      throw StateError('Firebase is not initialized. Call initialize() first.');
    }
    return _remoteConfig;
  }

  /// 초기화 상태 확인
  bool get isInitialized => _isInitialized;

  /// Firebase 연결 상태 확인
  Future<bool> checkConnection() async {
    try {
      if (!_isInitialized) return false;

      // 간단한 Firestore 쿼리로 연결 상태 확인
      await _firestore.collection('_health').limit(1).get();
      return true;
    } catch (e) {
      print('Firebase connection check failed: $e');
      return false;
    }
  }

  /// 사용자 ID 설정 (인증 후)
  void setUserId(String userId) {
    // Firestore 보안 규칙에서 사용자별 접근 제어를 위해 사용
    // 실제 구현에서는 Firebase Auth와 연동
  }

  /// 에러 처리 및 로깅
  void logError(String operation, dynamic error, [StackTrace? stackTrace]) {
    print('Firebase Error in $operation: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }

    // 실제 프로덕션에서는 Crashlytics나 다른 에러 추적 서비스 사용
  }
}
