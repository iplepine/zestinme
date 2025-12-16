import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zestinme/core/models/sleep_record.dart'; // Core model
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:zestinme/features/sleep_record/presentation/home/sleep_home_page.dart';

// Mock DB Service
class MockLocalDbService extends Mock implements LocalDbService {}

void main() {
  group('SleepHomePage Integration Tests', () {
    late MockLocalDbService mockDbService;
    late ProviderContainer container;

    setUp(() {
      mockDbService = MockLocalDbService();

      // Default stub
      when(
        () => mockDbService.getSleepRecordsByRange(any(), any()),
      ).thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [
          sleepHomeControllerProvider.overrideWith(
            (ref) => SleepHomeController(mockDbService),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('전체 플로우', () {
      testWidgets('로딩부터 데이터 표시까지의 전체 플로우를 테스트한다', (tester) async {
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

        // Override mock with delay to test loading state
        when(
          () => mockDbService.getSleepRecordsByRange(any(), any()),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockRecords;
        });

        // Re-create container for this test specifically if needed,
        // or just rely on setUp if we move constraints there.
        // Since we changed stub matching (any,any), it should work.
        // Ideally we should rebuild container to ensure fresh controller.

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(mockDbService),
            ),
          ],
        );

        // When - 초기 렌더링
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 로딩 상태 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 데이터 로딩 완료 대기
        await tester.pump(const Duration(milliseconds: 150));

        // Then - 데이터 상태 확인
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Sleep Tracker'), findsOneWidget);
      });

      testWidgets('에러 발생 시 에러 메시지가 표시된다', (tester) async {
        // Given
        when(
          () => mockDbService.getSleepRecordsByRange(any(), any()),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          throw Exception('테스트 에러');
        });

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(mockDbService),
            ),
          ],
        );

        // When
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 로딩 상태 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 에러 발생 대기
        await tester.pump(const Duration(milliseconds: 150));

        // Then - 에러 상태 확인
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Error: Exception: 테스트 에러'), findsOneWidget);
      });

      testWidgets('빈 데이터일 때 차트가 올바르게 표시된다', (tester) async {
        // Given
        when(
          () => mockDbService.getSleepRecordsByRange(any(), any()),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return [];
        });

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(mockDbService),
            ),
          ],
        );

        // When
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 로딩 상태 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 데이터 로딩 완료 대기
        await tester.pump(const Duration(milliseconds: 150));

        // Then - 빈 데이터 상태 확인
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Sleep Tracker'), findsOneWidget);
      });
    });

    testWidgets('작성하기 버튼을 왼쪽으로 드래그하면 잠들기 전 기록 작성 화면으로 이동한다', (tester) async {
      // Given
      when(
        () => mockDbService.getSleepRecordsByRange(any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // When - "작성하기" 버튼 찾기
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      // "작성하기" 버튼을 왼쪽으로 드래그
      await tester.drag(fabFinder, const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Then - 잠들기 전 기록 작성 화면으로 이동했는지 확인
      expect(find.text('잠들기 전 기록'), findsOneWidget);
    });

    testWidgets('작성하기 버튼을 오른쪽으로 드래그하면 일어난 후 기록 작성 화면으로 이동한다', (tester) async {
      // Given
      when(
        () => mockDbService.getSleepRecordsByRange(any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // When - "작성하기" 버튼 찾기
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      // "작성하기" 버튼을 오른쪽으로 드래그
      await tester.drag(fabFinder, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Then - 일어난 후 기록 작성 화면으로 이동했는지 확인
      expect(find.text('일어난 후 기록'), findsOneWidget);
    });
  });
}
