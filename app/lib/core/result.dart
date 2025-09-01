/// Result 타입을 나타내는 sealed class
sealed class Result<T> {
  const Result();
}

/// 성공 결과를 나타냄
class Ok<T> extends Result<T> {
  final T value;
  
  const Ok(this.value);
  
  @override
  String toString() => 'Ok($value)';
}

/// 에러 결과를 나타냄
class Err<T> extends Result<T> {
  final String message;
  final Object? exception;
  
  const Err(this.message, [this.exception]);
  
  @override
  String toString() => 'Err($message${exception != null ? ', $exception' : ''})';
}
