/// 앱 전체에서 사용하는 상수들
class AppConstants {
  // 앱 정보
  static const String appName = 'FullCon';
  static const String appDisplayName = '풀컨';
  static const String appVersion = '1.0.0';
  
  // API 관련
  static const String baseUrl = 'https://api.example.com';
  static const int timeoutDuration = 30000; // 30초
  
  // 공통 메시지
  static const String networkError = '네트워크 오류가 발생했습니다';
  static const String unknownError = '알 수 없는 오류가 발생했습니다';
  static const String serverError = '서버 오류가 발생했습니다';
  static const String cacheError = '캐시 오류가 발생했습니다';
  
  // 공통 값
  static const int maxRetryAttempts = 3;
  static const Duration cacheExpiration = Duration(hours: 24);
} 
