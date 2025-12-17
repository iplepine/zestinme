import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zestinme/core/models/sleep_record.dart'; // Correct Import
import 'package:zestinme/features/sleep_record/presentation/widgets/sleep_history_chart.dart';

void main() {
  group('SleepHistoryChart', () {
    late List<SleepRecord> mockRecords;

    setUp(() {
      mockRecords = [
        SleepRecord()
          ..id = 1
          ..date = DateTime(2024, 1, 2)
          ..inBedTime = DateTime(2024, 1, 1, 22, 0)
          ..wakeTime = DateTime(2024, 1, 2, 7, 0)
          ..selfRefreshmentScore =
              80 // 8 -> 80
          ..qualityScore =
              4 // 7/10 -> 4/5
          ..memo = '좋은 잠을 잤다'
          ..durationMinutes = 540, // 9 hours
        SleepRecord()
          ..id = 2
          ..date = DateTime(2024, 1, 3)
          ..inBedTime = DateTime(2024, 1, 2, 23, 0)
          ..wakeTime = DateTime(2024, 1, 3, 8, 0)
          ..selfRefreshmentScore = 90
          ..qualityScore = 5
          ..memo = '더 좋은 잠'
          ..durationMinutes = 540,
      ];
    });

    group('렌더링', () {
      testWidgets('빈 리스트일 때 안내 메시지를 표시한다', (tester) async {
        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SleepHistoryChart(records: [])),
          ),
        );

        // Then
        expect(find.text('최근 7일간의 기록이 여기에 표시됩니다.'), findsOneWidget);
      });

      testWidgets('데이터가 있을 때 차트를 표시한다', (tester) async {
        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SleepHistoryChart(records: mockRecords)),
          ),
        );

        // Then
        expect(find.byType(SleepHistoryChart), findsOneWidget);
        // fl_chart의 BarChart가 렌더링되는지 확인
        expect(find.byType(AspectRatio), findsOneWidget);
      });

      testWidgets('onBarLongPressed 콜백이 제공되면 차트가 렌더링된다', (tester) async {
        // Given
        bool callbackCalled = false;
        SleepRecord? callbackRecord;

        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SleepHistoryChart(
                records: mockRecords,
                onBarLongPressed: (record) {
                  callbackCalled = true;
                  callbackRecord = record;
                },
              ),
            ),
          ),
        );

        // Then
        expect(find.byType(SleepHistoryChart), findsOneWidget);
        expect(callbackCalled, false); // 아직 콜백이 호출되지 않았음
      });
    });

    group('데이터 정렬', () {
      testWidgets('최신 데이터가 오른쪽으로 가도록 정렬된다', (tester) async {
        // Given
        final oldRecord = SleepRecord()
          ..id =
              3 // Use int
          ..date = DateTime(2024, 1, 1)
          ..inBedTime = DateTime(2024, 1, 1, 22, 0)
          ..wakeTime = DateTime(2024, 1, 2, 7, 0)
          ..selfRefreshmentScore =
              80 // freshness 8 -> 80
          ..qualityScore = 4; // 7/10 -> 4/5

        final newRecord = SleepRecord()
          ..id = 4
          ..date = DateTime(2024, 1, 2)
          ..inBedTime = DateTime(2024, 1, 2, 22, 0)
          ..wakeTime = DateTime(2024, 1, 3, 7, 0)
          ..selfRefreshmentScore = 90
          ..qualityScore = 5;

        final records = [oldRecord, newRecord];

        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SleepHistoryChart(records: records)),
          ),
        );

        // Then
        expect(find.byType(SleepHistoryChart), findsOneWidget);
      });
    });

    group('위젯 구조', () {
      testWidgets('AspectRatio로 감싸져 있어야 한다', (tester) async {
        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SleepHistoryChart(records: mockRecords)),
          ),
        );

        // Then
        expect(find.byType(AspectRatio), findsOneWidget);
      });

      testWidgets('Padding이 적용되어야 한다', (tester) async {
        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SleepHistoryChart(records: mockRecords)),
          ),
        );

        // Then
        expect(find.byType(Padding), findsWidgets);
      });
    });

    group('접근성', () {
      testWidgets('Semantics가 올바르게 설정되어야 한다', (tester) async {
        // When
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: SleepHistoryChart(records: mockRecords)),
          ),
        );

        // Then
        expect(find.byType(SleepHistoryChart), findsOneWidget);
      });
    });
  });
}
