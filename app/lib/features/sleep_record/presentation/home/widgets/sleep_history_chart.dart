import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zestinme/core/models/sleep_record.dart';

class SleepHistoryChart extends StatefulWidget {
  final List<SleepRecord> records;
  final Function(SleepRecord) onRecordSelected;

  const SleepHistoryChart({
    super.key,
    required this.records,
    required this.onRecordSelected,
  });

  @override
  State<SleepHistoryChart> createState() => _SleepHistoryChartState();
}

class _SleepHistoryChartState extends State<SleepHistoryChart> {
  int? _selectedSpotIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) {
      return const Center(child: Text('기록이 없습니다.'));
    }

    final sortedRecords = List<SleepRecord>.from(widget.records)
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = sortedRecords
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(
            entry.value.date.millisecondsSinceEpoch.toDouble(),
            entry.value.averageScore,
          ),
        )
        .toList();

    final lineBars = <LineChartBarData>[];
    if (sortedRecords.isNotEmpty) {
      var currentSpots = <FlSpot>[];
      bool? isCurrentSegmentCompleted;

      void addLineBar() {
        if (currentSpots.isNotEmpty) {
          final isCompleted = isCurrentSegmentCompleted ?? false;
          lineBars.add(
            LineChartBarData(
              spots: List.of(currentSpots),
              isCurved: true,
              color: isCompleted ? Theme.of(context).primaryColor : Colors.grey,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final recordIndex = sortedRecords.indexWhere(
                    (r) => r.date.millisecondsSinceEpoch.toDouble() == spot.x,
                  );

                  final isSelected = recordIndex == _selectedSpotIndex;
                  return FlDotCirclePainter(
                    radius: isSelected ? 8 : 5,
                    color: isCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color:
                    (isCompleted ? Theme.of(context).primaryColor : Colors.grey)
                        .withOpacity(0.3),
              ),
            ),
          );
        }
      }

      for (int i = 0; i < sortedRecords.length; i++) {
        final spot = spots[i];
        currentSpots.add(spot);
        isCurrentSegmentCompleted =
            true; // Assume all core records are completed for now
      }
      addLineBar();
    }

    return LineChart(
      LineChartData(
        lineBarsData: lineBars,
        showingTooltipIndicators:
            _selectedSpotIndex != null && _selectedSpotIndex! < spots.length
            ? [
                ShowingTooltipIndicators([
                  LineBarSpot(
                    lineBars.firstWhere(
                      (bar) => bar.spots.any(
                        (s) => s.x == spots[_selectedSpotIndex!].x,
                      ),
                    ),
                    spots.indexOf(spots[_selectedSpotIndex!]),
                    spots[_selectedSpotIndex!],
                  ),
                ]),
              ]
            : [],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.blueAccent.withOpacity(0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final record = sortedRecords[spot.spotIndex];
                final date = DateFormat('M/d(E)', 'ko_KR').format(record.date);
                final score = record.averageScore.toStringAsFixed(1);

                return LineTooltipItem(
                  '$date\n평균 점수: $score',
                  const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.left,
                );
              }).toList();
            },
          ),
          touchCallback: (event, response) {
            if (event is FlTapUpEvent) {
              if (response == null ||
                  response.lineBarSpots == null ||
                  response.lineBarSpots!.isEmpty) {
                setState(() {
                  _selectedSpotIndex = null;
                });
                return;
              }
              final spotIndex = response.lineBarSpots!.first.spotIndex;
              setState(() {
                if (_selectedSpotIndex == spotIndex) {
                  _selectedSpotIndex = null;
                } else {
                  _selectedSpotIndex = spotIndex;
                  widget.onRecordSelected(sortedRecords[spotIndex]);
                }
              });
            }
          },
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return const FlLine(color: Colors.white10, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(color: Colors.white10, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: const Duration(days: 1).inMilliseconds.toDouble(),
              getTitlesWidget: _bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: _leftTitleWidgets,
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: spots.isNotEmpty
            ? spots.first.x -
                  (const Duration(days: 1).inMilliseconds.toDouble() / 2)
            : 0,
        maxX: spots.isNotEmpty
            ? spots.last.x +
                  (const Duration(days: 1).inMilliseconds.toDouble() / 2)
            : 0,
        minY: 0,
        maxY: 11,
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(DateFormat('M/d').format(dt), style: style),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '2';
        break;
      case 5:
        text = '5';
        break;
      case 8:
        text = '8';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
