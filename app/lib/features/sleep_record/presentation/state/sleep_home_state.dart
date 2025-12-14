import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/models/sleep_record.dart';

part 'sleep_home_state.freezed.dart';

@freezed
class SleepHomeState with _$SleepHomeState {
  const factory SleepHomeState.loading() = _Loading;
  const factory SleepHomeState.data(List<SleepRecord> records) = _Data;
  const factory SleepHomeState.error(String message) = _Error;
}
