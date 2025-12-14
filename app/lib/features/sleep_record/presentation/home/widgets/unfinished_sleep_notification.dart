import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:zestinme/core/models/sleep_record.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/features/sleep_record/presentation/screens/sleep_record_screen.dart';
import '../../controller/sleep_home_controller.dart';

class UnfinishedSleepNotification extends ConsumerStatefulWidget {
  final VoidCallback? onDismissed;
  const UnfinishedSleepNotification({super.key, this.onDismissed});

  @override
  ConsumerState<UnfinishedSleepNotification> createState() =>
      _UnfinishedSleepNotificationState();
}

class _UnfinishedSleepNotificationState
    extends ConsumerState<UnfinishedSleepNotification> {
  Future<SleepRecord?>? _unfinishedRecordFuture;

  @override
  void initState() {
    super.initState();
    _loadUnfinishedRecord();
  }

  void _loadUnfinishedRecord() {
    _unfinishedRecordFuture = _fetchUnfinishedRecord();
  }

  Future<SleepRecord?> _fetchUnfinishedRecord() async {
    final db = GetIt.I<LocalDbService>();
    final now = DateTime.now();
    // Check records from last 24 hours
    final records = await db.getSleepRecordsByRange(
      now.subtract(const Duration(hours: 24)),
      now,
    );

    // Find incomplete record (assuming short duration < 10 mins means incomplete/just started)
    return records.where((r) => r.durationMinutes < 10).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SleepRecord?>(
      future: _unfinishedRecordFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final unfinishedRecord = snapshot.data!;
        // sleep_record id is int (Id), ValueKey usually takes String or int.
        // ValueKey<int> is valid.
        final key = ValueKey<int>(unfinishedRecord.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Dismissible(
              key: key,
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                if (widget.onDismissed != null) {
                  widget.onDismissed!();
                }
              },
              background: Container(
                color: Colors.redAccent,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.delete_sweep, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete_sweep, color: Colors.white),
                    ),
                  ],
                ),
              ),
              child: _NotificationContent(
                record: unfinishedRecord,
                onTap: () =>
                    _navigateToRecordScreen(context, ref, unfinishedRecord),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToRecordScreen(
    BuildContext context,
    WidgetRef ref,
    SleepRecord record,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => SleepRecordScreen(initialRecord: record),
          ),
        )
        .then((_) {
          // Refresh regardless of result
          ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
          setState(() {
            _unfinishedRecordFuture = null; // Hide notification or reload
          });
        });
  }
}

class _NotificationContent extends StatelessWidget {
  final SleepRecord record;
  final VoidCallback onTap;

  const _NotificationContent({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.bedtime, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '미완성 수면 기록',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${record.bedTime.hour.toString().padLeft(2, '0')}:${record.bedTime.minute.toString().padLeft(2, '0')}에 잠든 기록이 있습니다',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '완료하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
