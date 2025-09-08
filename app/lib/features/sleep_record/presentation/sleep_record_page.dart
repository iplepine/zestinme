import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zestinme/core/errors/failures.dart';

import '../../../di/injection.dart';
import '../domain/models/sleep_record.dart';
import '../domain/usecases/add_sleep_record_usecase.dart';
import '../domain/usecases/delete_sleep_record_usecase.dart';
import '../domain/usecases/update_sleep_record_usecase.dart';
import 'sleep_guide_page.dart';
import 'widgets/date_time_selection_widget.dart';

// 수면 기록용 색상 팔레트
class SleepColors {
  static const primary = Color(0xFF6366F1); // 인디고
  static const primaryForeground = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFE0E7FF); // 인디고 100
  static const secondaryForeground = Color(0xFF1E1B4B);
  static const accent = Color(0xFF8B5CF6); // 바이올렛
  static const accentForeground = Color(0xFFFFFFFF);
  static const muted = Color(0xFFF8FAFC);
  static const mutedForeground = Color(0xFF64748B);
  static const background = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF0F172A);
  static const border = Color(0xFFE2E8F0);
}

class SleepRecordPage extends StatefulWidget {
  final SleepRecord? initialRecord;

  const SleepRecordPage({super.key, this.initialRecord});

  @override
  State<SleepRecordPage> createState() => _SleepRecordPageState();
}

class _SleepRecordPageState extends State<SleepRecordPage> {
  final _formKey = GlobalKey<FormState>();

  // 필수 항목
  late DateTime _sleepDateTime;
  late DateTime _wakeDateTime;
  late int _sleepQuality; // 수면의 질 (1-5점)
  late int _morningMood; // 아침 상태 (1-5점)

  // 선택 항목
  int _awakenings = 0; // 밤중 각성 횟수
  String? _bedtimeActivity; // 취침 전 활동
  bool _caffeineAfter6pm = false; // 카페인/알코올 섭취
  int _stressLevel = 3; // 스트레스 수준

  // UI 상태
  bool _showOptionalFields = false;
  bool _isLoading = false;

  final _contentController = TextEditingController();
  final _disruptionController = TextEditingController();

  bool get _isUpdateMode => widget.initialRecord != null;
  late final bool _isNightMode;

  @override
  void initState() {
    super.initState();
    _loadLastInputs();
    // 진입 시점에 night 모드 여부를 한 번만 결정
    _isNightMode =
        widget.initialRecord != null &&
        widget.initialRecord!.sleepTime == widget.initialRecord!.wakeTime;
    if (_isUpdateMode) {
      final record = widget.initialRecord!;
      _sleepDateTime = record.sleepTime;
      _wakeDateTime = record.wakeTime;
      _sleepQuality = record.sleepSatisfaction;
      _morningMood = record.freshness;
      _contentController.text = record.content ?? '';
      _disruptionController.text = record.disruptionFactors ?? '';
    } else {
      _initializeDefaultTimes();
    }
  }

  void _loadLastInputs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 마지막 입력값 불러오기 (편의성 향상)
      _sleepQuality = prefs.getInt('last_sleep_quality') ?? 3;
      _morningMood = prefs.getInt('last_morning_mood') ?? 3;
      _awakenings = prefs.getInt('last_awakenings') ?? 0;
      _stressLevel = prefs.getInt('last_stress_level') ?? 3;
    });
  }

  Future<void> _saveInputs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_sleep_quality', _sleepQuality);
    await prefs.setInt('last_morning_mood', _morningMood);
    await prefs.setInt('last_awakenings', _awakenings);
    await prefs.setInt('last_stress_level', _stressLevel);
  }

  String _getSleepDuration() {
    final bedtimeMinutes = _sleepDateTime.hour * 60 + _sleepDateTime.minute;
    final wakeMinutes = _wakeDateTime.hour * 60 + _wakeDateTime.minute;

    int durationMinutes = wakeMinutes - bedtimeMinutes;
    if (durationMinutes < 0) durationMinutes += 24 * 60; // 다음날 기상

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    return '${hours}시간 ${minutes}분';
  }

  int _calculateSleepScore() {
    int score = 0;

    // 수면 시간 점수 (7-9시간이 최적)
    final duration = _getSleepDuration();
    if (duration.contains('7시간') ||
        duration.contains('8시간') ||
        duration.contains('9시간')) {
      score += 30;
    } else if (duration.contains('6시간') || duration.contains('10시간')) {
      score += 20;
    } else {
      score += 10;
    }

    // 수면의 질 점수
    score += _sleepQuality * 10;

    // 아침 상태 점수
    score += _morningMood * 8;

    // 밤중 각성 감점
    score -= _awakenings * 5;

    return score.clamp(0, 100);
  }

  void _initializeDefaultTimes() {
    final now = DateTime.now();

    if (widget.initialRecord != null) {
      // initialRecord가 있으면 해당 값으로 설정
      _sleepDateTime = widget.initialRecord!.sleepTime;
      _wakeDateTime = widget.initialRecord!.wakeTime;
      _sleepQuality = widget.initialRecord!.sleepSatisfaction;
      _morningMood = widget.initialRecord!.freshness;
      _disruptionController.text =
          widget.initialRecord!.disruptionFactors ?? '';
    } else {
      // 기본 모드: 기존 로직
      _wakeDateTime = now;
      final recommendedSleepTime = now.subtract(const Duration(hours: 8));
      _sleepDateTime = recommendedSleepTime;
      _sleepQuality = 3;
      _morningMood = 3;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _disruptionController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        await _saveInputs();

        if (_isUpdateMode) {
          await _updateRecord();
        } else {
          await _createRecord();
        }

        final sleepScore = _calculateSleepScore();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('수면 기록 완료! 수면 점수: $sleepScore점'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('저장 중 오류가 발생했습니다: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _createRecord() async {
    final now = DateTime.now();
    var sleepDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _sleepDateTime.hour,
      _sleepDateTime.minute,
    );
    final wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeDateTime.hour,
      _wakeDateTime.minute,
    );

    if (sleepDateTime.isAfter(wakeDateTime)) {
      sleepDateTime = sleepDateTime.subtract(const Duration(days: 1));
    }

    final newRecord = SleepRecord(
      id: UniqueKey().toString(),
      sleepTime: sleepDateTime,
      wakeTime: wakeDateTime,
      freshness: _morningMood,
      sleepSatisfaction: _sleepQuality,
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
      _sleepDateTime.hour,
      _sleepDateTime.minute,
    );
    final wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeDateTime.hour,
      _wakeDateTime.minute,
    );

    if (sleepDateTime.isAfter(wakeDateTime)) {
      sleepDateTime = sleepDateTime.subtract(const Duration(days: 1));
    }

    final updatedRecord = widget.initialRecord!.copyWith(
      sleepTime: sleepDateTime,
      wakeTime: wakeDateTime,
      freshness: _morningMood,
      sleepSatisfaction: _sleepQuality,
      disruptionFactors: _disruptionController.text,
      fatigue: _stressLevel, // 스트레스 수준을 피로도로 사용
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
              // 잠든 시간 선택
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SleepColors.muted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SleepColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SleepColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.bedtime,
                            color: SleepColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '잠든 시간',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: SleepColors.foreground,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DateTimeSelectionWidget(
                      selectedDateTime: _sleepDateTime,
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          _sleepDateTime = newDateTime;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 일어난 시간 선택
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SleepColors.muted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SleepColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SleepColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.wb_sunny,
                            color: SleepColors.accent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '일어난 시간',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: SleepColors.foreground,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DateTimeSelectionWidget(
                      selectedDateTime: _wakeDateTime,
                      onDateTimeChanged: _isNightMode
                          ? null
                          : (DateTime newDateTime) {
                              setState(() {
                                _wakeDateTime = newDateTime;
                              });
                            },
                    ),
                  ],
                ),
              ),
              if (_isNightMode)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    '잠든 시간 기록 모드에서는 잠든 시간만 입력할 수 있습니다.',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 16),

              // 수면 시간 요약 카드
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      SleepColors.primary.withValues(alpha: 0.1),
                      SleepColors.accent.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SleepColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SleepColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.schedule,
                        color: SleepColors.primaryForeground,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '예상 수면 시간',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: SleepColors.foreground,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getSleepDuration().isEmpty
                                ? '시간을 선택해주세요'
                                : _getSleepDuration(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: SleepColors.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (_getSleepDuration().isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: SleepColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getSleepDuration().contains('7시간') ||
                                  _getSleepDuration().contains('8시간') ||
                                  _getSleepDuration().contains('9시간')
                              ? '👍'
                              : _getSleepDuration().contains('6시간') ||
                                    _getSleepDuration().contains('10시간')
                              ? '👌'
                              : '⚠️',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSlider(
                label: '수면의 질',
                subtitle: '어젯밤 잠은 어떠셨나요?',
                value: _sleepQuality,
                onChanged: (v) => setState(() => _sleepQuality = v),
                enabled: !_isNightMode,
                min: 1,
                max: 5,
                labels: const ['매우 나쁨', '나쁨', '보통', '좋음', '매우 좋음'],
              ),
              const SizedBox(height: 24),
              _buildSlider(
                label: '아침 상태',
                subtitle: '오늘 아침 기분은 어떠신가요?',
                value: _morningMood,
                onChanged: (v) => setState(() => _morningMood = v),
                enabled: !_isNightMode,
                min: 1,
                max: 5,
                labels: const ['매우 피곤', '피곤', '보통', '상쾌', '매우 상쾌'],
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

              // 선택 항목 토글
              GestureDetector(
                onTap: () =>
                    setState(() => _showOptionalFields = !_showOptionalFields),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _showOptionalFields
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.purple[600],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '심화 분석 (선택사항)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.purple[700],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _showOptionalFields ? '접기' : '펼치기',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.purple[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 선택 항목들
              if (_showOptionalFields) ...[
                const SizedBox(height: 16),

                // 밤중 각성 횟수
                _buildSlider(
                  label: '밤중 각성 횟수',
                  subtitle: '밤에 몇 번 깼나요?',
                  value: _awakenings,
                  onChanged: (v) => setState(() => _awakenings = v),
                  enabled: !_isNightMode,
                  min: 0,
                  max: 5,
                  labels: const ['0회', '1회', '2회', '3회', '4회', '5회 이상'],
                ),

                const SizedBox(height: 16),

                // 취침 전 활동
                _buildDropdownInput(
                  title: '취침 전 활동',
                  subtitle: '잠들기 전 1시간 동안 무엇을 했나요?',
                  value: _bedtimeActivity,
                  onChanged: (value) =>
                      setState(() => _bedtimeActivity = value),
                  items: const [
                    '스마트폰 사용',
                    '독서',
                    'TV 시청',
                    '명상/요가',
                    '음악 감상',
                    '대화',
                    '기타',
                  ],
                  enabled: !_isNightMode,
                ),

                const SizedBox(height: 16),

                // 카페인/알코올 섭취
                _buildSwitchInput(
                  title: '카페인/알코올 섭취',
                  subtitle: '어제 오후 6시 이후 마셨나요?',
                  value: _caffeineAfter6pm,
                  onChanged: (value) =>
                      setState(() => _caffeineAfter6pm = value),
                  enabled: !_isNightMode,
                ),

                const SizedBox(height: 16),

                // 스트레스 수준
                _buildSlider(
                  label: '스트레스 수준',
                  subtitle: '어제 스트레스는 어떠셨나요?',
                  value: _stressLevel,
                  onChanged: (v) => setState(() => _stressLevel = v),
                  enabled: !_isNightMode,
                  min: 1,
                  max: 5,
                  labels: const ['매우 낮음', '낮음', '보통', '높음', '매우 높음'],
                ),
              ],
              const SizedBox(height: 16),

              // 수면 점수 미리보기
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[50]!, Colors.orange[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.amber[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '예상 수면 점수: ${_calculateSleepScore()}점',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
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
            onPressed: _isLoading ? null : _onSave,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: SleepColors.primary,
              foregroundColor: SleepColors.primaryForeground,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('수면 기록 저장하기'),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    String? subtitle,
    required int value,
    required ValueChanged<int> onChanged,
    bool enabled = true,
    int min = 1,
    int max = 5,
    List<String>? labels,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: SleepColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.star, color: SleepColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                labels != null ? labels[value - min] : '$value',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SleepColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            activeColor: SleepColors.primary,
            inactiveColor: SleepColors.border,
            onChanged: enabled
                ? (newValue) => onChanged(newValue.round())
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownInput({
    required String title,
    required String subtitle,
    required String? value,
    required ValueChanged<String?> onChanged,
    required List<String> items,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: SleepColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.phone_android,
                  color: SleepColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: SleepColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            hint: const Text('선택하세요'),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchInput({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SleepColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.local_cafe, color: SleepColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: SleepColors.primary,
          ),
        ],
      ),
    );
  }
}
