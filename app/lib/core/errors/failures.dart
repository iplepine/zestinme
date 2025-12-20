import 'package:zestinme/core/models/sleep_record.dart';
import 'package:intl/intl.dart';

/// 앱 전체에서 사용하는 에러 타입들
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// 서버 관련 에러
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// 네트워크 관련 에러
class NetworkFailure implements Exception {
  final String message;
  NetworkFailure(this.message);
}

class SleepTimeOverlapException implements Exception {
  final SleepRecord overlappingRecord;

  SleepTimeOverlapException(this.overlappingRecord);

  @override
  String toString() {
    final sleepTime = DateFormat.Hm().format(overlappingRecord.inBedTime);
    final wakeTime = DateFormat.Hm().format(overlappingRecord.wakeTime);
    return '이미 ${sleepTime} ~ ${wakeTime} 기록과 시간이 겹칩니다.';
  }
}

/// 캐시 관련 에러
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// 인증 관련 에러
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// 유효성 검사 에러
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
