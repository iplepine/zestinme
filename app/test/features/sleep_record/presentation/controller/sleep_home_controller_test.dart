import 'package:flutter_test/flutter_test.dart';
import 'package:zestinme/core/models/sleep_record.dart'; // Correct Import
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:zestinme/features/sleep_record/presentation/state/sleep_home_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDbService extends Mock implements LocalDbService {}

void main() {
  group('SleepHomeController', () {
    late SleepHomeController controller;
    late MockLocalDbService mockDbService;

    setUp(() {
      mockDbService = MockLocalDbService();
      // Setup default mock response
      when(
        () => mockDbService.getSleepRecordsByRange(any(), any()),
      ).thenAnswer((_) async => []);

      controller = SleepHomeController(mockDbService);
    });

    group('초기화', () {
      test('초기화 시 fetchRecords가 호출되어야 한다', () async {
        // Given
        final mockRecords = [
          SleepRecord()
            ..id = 1
            ..inBedTime = DateTime(2024, 1, 1, 22, 0)
            ..wakeTime = DateTime(2024, 1, 2, 7, 0)
            ..qualityScore = 3
            ..memo = '좋은 잠을 잤다'
            ..tags = []
            ..date = DateTime(2024, 1, 2),
        ];

        when(
          () => mockDbService.getSleepRecordsByRange(any(), any()),
        ).thenAnswer((_) async => mockRecords);

        controller = SleepHomeController(mockDbService);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        // Note: SleepHomeState equality might rely on list equality which refers to the same instance or deep equality
        // Assuming SleepHomeState uses freezed or equatable.
        // Also MockLocalDbService returns the same list instance, so it should match.
        expect(controller.state, SleepHomeState.data(mockRecords));
      });
    });

    group('fetchRecords', () {
      test('성공적으로 데이터를 가져오면 data 상태가 되어야 한다', () async {
        // Given
        final mockRecords = [
          SleepRecord()
            ..id = 1
            ..inBedTime = DateTime(2024, 1, 1, 22, 0)
            ..wakeTime = DateTime(2024, 1, 2, 7, 0),
        ];

        when(
          () => mockDbService.getSleepRecordsByRange(any(), any()),
        ).thenAnswer((_) async => mockRecords);

        controller = SleepHomeController(mockDbService);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, SleepHomeState.data(mockRecords));
      });

      test('에러가 발생하면 error 상태가 되어야 한다', () async {
        // Given
        final exception = Exception('테스트 에러');
        when(
          () => mockDbService.getSleepRecordsByRange(any(), any()),
        ).thenThrow(exception);

        controller = SleepHomeController(mockDbService);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, SleepHomeState.error(exception.toString()));
      });
    });
  });
}
