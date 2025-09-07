import 'package:flutter/material.dart';
import 'package:zestinme/core/errors/failures.dart';

import '../../../di/injection.dart';
import '../domain/models/sleep_record.dart';
import '../domain/usecases/add_sleep_record_usecase.dart';
import '../domain/usecases/delete_sleep_record_usecase.dart';
import '../domain/usecases/update_sleep_record_usecase.dart';
import 'sleep_guide_page.dart';

class SleepRecordPage extends StatefulWidget {
  final SleepRecord? initialRecord;

  const SleepRecordPage({super.key, this.initialRecord});

  @override
  State<SleepRecordPage> createState() => _SleepRecordPageState();
}

class _SleepRecordPageState extends State<SleepRecordPage> {
  final _formKey = GlobalKey<FormState>();

  late TimeOfDay _sleepTime;
  late TimeOfDay _wakeTime;
  late int _freshness;
  late int _sleepSatisfaction;
  int _fatigue = 5; // 수정 모드에서의 기본값

  final _contentController = TextEditingController();
  final _disruptionController = TextEditingController();

  bool get _isUpdateMode => widget.initialRecord != null;
  bool _canEditFatigue = false;
  late final bool _isNightMode;

  @override
  void initState() {
    super.initState();
    // 진입 시점에 night 모드 여부를 한 번만 결정
    _isNightMode =
        widget.initialRecord != null &&
        widget.initialRecord!.sleepTime == widget.initialRecord!.wakeTime;
    if (_isUpdateMode) {
      final record = widget.initialRecord!;
      _sleepTime = TimeOfDay.fromDateTime(record.sleepTime);
      _wakeTime = TimeOfDay.fromDateTime(record.wakeTime);
      _freshness = record.freshness;
      _sleepSatisfaction = record.sleepSatisfaction;
      _fatigue = record.fatigue ?? 5;
      _contentController.text = record.content ?? '';
      _disruptionController.text = record.disruptionFactors ?? '';

      // 피로도 수정 가능 여부 체크
      final now = DateTime.now();
      _canEditFatigue = record.wakeTime.isBefore(
        now.subtract(const Duration(hours: 1)),
      );
    } else {
      _initializeDefaultTimes();
    }
  }

  void _initializeDefaultTimes() {
    final now = DateTime.now();

    if (widget.initialRecord != null) {
      // initialRecord가 있으면 해당 값으로 설정
      _sleepTime = TimeOfDay.fromDateTime(widget.initialRecord!.sleepTime);
      _wakeTime = TimeOfDay.fromDateTime(widget.initialRecord!.wakeTime);
      _freshness = widget.initialRecord!.freshness;
      _sleepSatisfaction = widget.initialRecord!.sleepSatisfaction;
      _disruptionController.text =
          widget.initialRecord!.disruptionFactors ?? '';
    } else {
      // 기본 모드: 기존 로직
      _wakeTime = TimeOfDay.fromDateTime(now);
      final recommendedSleepTime = now.subtract(const Duration(hours: 8));
      _sleepTime = TimeOfDay.fromDateTime(recommendedSleepTime);
      _freshness = 5;
      _sleepSatisfaction = 5;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _disruptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context, {
    required bool isSleepTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isSleepTime ? _sleepTime : _wakeTime,
    );
    if (picked != null) {
      setState(() {
        if (isSleepTime) {
          _sleepTime = picked;
        } else {
          _wakeTime = picked;
        }
      });
    }
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isUpdateMode) {
        _updateRecord();
      } else {
        _createRecord();
      }
    }
  }

  Future<void> _createRecord() async {
    final now = DateTime.now();
    var sleepDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _sleepTime.hour,
      _sleepTime.minute,
    );
    final wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    if (sleepDateTime.isAfter(wakeDateTime)) {
      sleepDateTime = sleepDateTime.subtract(const Duration(days: 1));
    }

    final newRecord = SleepRecord(
      id: UniqueKey().toString(),
      sleepTime: sleepDateTime,
      wakeTime: wakeDateTime,
      freshness: _freshness,
      sleepSatisfaction: _sleepSatisfaction,
      disruptionFactors: _disruptionController.text,
      createdAt: now,
      // 생성 시에는 피로도 관련 정보는 null
      fatigue: null,
      content: null,
    );

    final useCase = Injection.getIt<AddSleepRecordUseCase>();
    try {
      await useCase(newRecord);
      if (mounted) Navigator.pop(context, true);
    } on SleepTimeOverlapException catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
    }
  }

  Future<void> _updateRecord() async {
    final now = DateTime.now();
    var sleepDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _sleepTime.hour,
      _sleepTime.minute,
    );
    final wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    if (sleepDateTime.isAfter(wakeDateTime)) {
      sleepDateTime = sleepDateTime.subtract(const Duration(days: 1));
    }

    final updatedRecord = widget.initialRecord!.copyWith(
      sleepTime: sleepDateTime,
      wakeTime: wakeDateTime,
      freshness: _freshness,
      sleepSatisfaction: _sleepSatisfaction,
      disruptionFactors: _disruptionController.text,
      fatigue: _fatigue,
      content: _contentController.text,
    );

    final useCase = Injection.getIt<UpdateSleepRecordUseCase>();
    try {
      await useCase(updatedRecord);
      if (mounted) Navigator.pop(context, true);
    } on SleepTimeOverlapException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
    }
  }

  Future<void> _deleteRecord() async {
    if (!_isUpdateMode) return;

    try {
      final initialRecord = widget.initialRecord;
      if (initialRecord == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('삭제할 기록이 없습니다.')));
        }
        return;
      }
      final useCase = Injection.getIt<DeleteSleepRecordUseCase>();
      await useCase(initialRecord.id);
      if (mounted) {
        // 홈 화면으로 돌아가서 리스트 갱신
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')));
      }
    }
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('기록 삭제'),
          content: const Text('정말로 이 수면 기록을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _deleteRecord();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isNightMode ? '잠든 시간 기록' : (_isUpdateMode ? '수면 기록 편집' : '수면 기록하기'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SleepGuidePage()),
              );
            },
            tooltip: '수면기록 가이드',
          ),
          if (_isUpdateMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirmDialog,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // 날짜 표시 추가
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '기록 날짜',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isUpdateMode
                        ? _formatDate(widget.initialRecord!.sleepTime)
                        : _formatDate(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              // 잠든 시간만 수정 가능
              _buildTimePicker(
                label: '잠든 시간',
                time: _sleepTime,
                onTap: _isNightMode
                    ? () => _selectTime(context, isSleepTime: true)
                    : () => _selectTime(context, isSleepTime: true),
              ),
              const SizedBox(height: 16),
              // 나머지는 모두 비활성화
              _buildTimePicker(label: '일어난 시간', time: _wakeTime, onTap: null),
              if (_isNightMode)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    '잠든 시간 기록 모드에서는 잠든 시간만 입력할 수 있습니다.',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              _buildSlider(
                label: '잠에서 깼을 때의 상쾌함',
                value: _freshness,
                onChanged: (v) => setState(() => _freshness = v),
                enabled: !_isNightMode,
              ),
              const SizedBox(height: 24),
              _buildSlider(
                label: '수면 만족도',
                value: _sleepSatisfaction,
                onChanged: (v) => setState(() => _sleepSatisfaction = v),
                enabled: !_isNightMode,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _disruptionController,
                decoration: const InputDecoration(
                  labelText: '수면 방해 요인',
                  hintText: '예: 화장실 가느라 깸, 소음 등',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                enabled: !_isNightMode,
              ),
              const SizedBox(height: 24),
              _buildSlider(
                label: '하루 중 피로도',
                value: _fatigue,
                enabled: _isUpdateMode && _canEditFatigue && !_isNightMode,
                onChanged: (v) => setState(() => _fatigue = v),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: null,
                child: TextFormField(
                  controller: _contentController,
                  enabled: _isUpdateMode && _canEditFatigue && !_isNightMode,
                  decoration: const InputDecoration(
                    labelText: '피로도 관련 기록',
                    hintText: '예: 오후에 집중력 저하, 특정 스트레스 이벤트 등',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('저장'),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              label == '일어난 시간' && _isNightMode
                  ? '기상 후 입력'
                  : ((time.hour == 0 && time.minute == 0)
                        ? '시간 선택'
                        : time.format(context)),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: () {
        if (!enabled) {
          if (label == '하루 중 피로도' && _isUpdateMode && !_canEditFatigue) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('피로도는 기상 후 1시간 뒤부터 기록할 수 있습니다.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('피로도는 오후에 기록할 수 있습니다. 먼저 아침 수면 기록을 저장해주세요.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '$value',
                  onChanged: enabled ? (v) => onChanged(v.round()) : null,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text('$value', textAlign: TextAlign.right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
