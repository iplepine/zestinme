import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepGuidePage extends StatefulWidget {
  const SleepGuidePage({super.key});

  @override
  State<SleepGuidePage> createState() => _SleepGuidePageState();
}

class _SleepGuidePageState extends State<SleepGuidePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 목표 선택
  String? _selectedGoal;

  // 약속 설정
  bool _bedtimeReminder = true;
  bool _morningCheckin = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeGuide() async {
    // 설정 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sleep_guide_completed', true);
    await prefs.setString('sleep_goal', _selectedGoal ?? '');
    await prefs.setBool('bedtime_reminder', _bedtimeReminder);
    await prefs.setBool('morning_checkin', _morningCheckin);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // 진행률 표시
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_currentPage + 1}/4',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 페이지뷰
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildHookCard(),
                  _buildOptimalCard(),
                  _buildPersonalCard(),
                  _buildResultCard(),
                ],
              ),
            ),

            // 네비게이션 버튼
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        child: const Text('이전'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentPage < 3 ? _nextPage : _completeGuide,
                      child: Text(_currentPage < 3 ? '다음' : '7일 챌린지 시작'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHookCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아침형/저녁형 아이콘들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 아침형 아이콘
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[400]!, Colors.orange[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  size: 30,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 20),

              // 저녁형 아이콘
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo[400]!, Colors.purple[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.nights_stay,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 헤드라인
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: '아침형 인간',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.amber[700],
                    fontSize: 24,
                  ),
                ),
                const TextSpan(text: '이신가요,\n'),
                TextSpan(
                  text: '저녁형 인간',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.indigo[700],
                    fontSize: 24,
                  ),
                ),
                const TextSpan(text: '이신가요?'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 서브헤드라인
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(text: '모두가 똑같은 시간에 잠들 필요는 없어요.\n'),
                const TextSpan(text: '나만의 '),
                TextSpan(
                  text: '최적 수면 시간대',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.amber[700],
                    fontSize: 18,
                  ),
                ),
                const TextSpan(text: '를 찾으면,\n아침이 더 상쾌해집니다!'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 미니 예시 카드
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[50]!, Colors.orange[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '예시',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '어젯밤 11시에 잠들었더니\n→ 오늘 기분 +2, 집중력 +1',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimalCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 그라데이션 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.indigo[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.schedule, size: 40, color: Colors.white),
          ),

          const SizedBox(height: 32),

          // 헤드라인
          Text(
            '10초 기록으로 내 수면 리듬 찾기',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // 본문
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(text: '전문가는 '),
                TextSpan(
                  text: '7–9시간 수면',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const TextSpan(text: '을 권장하지만,\n'),
                const TextSpan(text: '언제 자고 일어나는가가 더 중요해요.\n'),
                const TextSpan(text: '간단히 기록하면 '),
                TextSpan(
                  text: '나만의 수면 스윗스팟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const TextSpan(text: '을 발견할 수 있습니다.'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 포인트 카드
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.indigo[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: '기록',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const TextSpan(text: ' → 내 최적 취침/기상 시간 파악\n'),
                      TextSpan(
                        text: '결과',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const TextSpan(text: ' → 더 가벼운 아침, 더 나은 하루'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 그라데이션 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[400]!, Colors.pink[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),

          const SizedBox(height: 32),

          // 헤드라인
          Text(
            '수면이 내 하루를 어떻게 바꿀까?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // 본문
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(text: '어젯밤 취침 시간과 활동을 기록하면,\n'),
                const TextSpan(text: '오늘의 '),
                TextSpan(
                  text: '상쾌함, 집중력, 기분',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                const TextSpan(text: '이 숫자로 보입니다.\n'),
                TextSpan(
                  text: '"내게 맞는 수면 패턴"',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                const TextSpan(text: '을 한눈에 파악하세요!'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 포인트 카드
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[50]!, Colors.pink[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple[100]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: Colors.purple[600],
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: '11시 취침 → 상쾌함 80%\n'),
                      const TextSpan(text: '1시 취침 → 집중력 50%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 그라데이션 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[400]!, Colors.teal[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 32),

          // 헤드라인
          Text(
            '7일만 기록하면 내 리듬이 보입니다!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // 본문
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(text: '매일 아침·밤 10초 기록으로 시작하세요.\n'),
                const TextSpan(text: '나만의 '),
                TextSpan(
                  text: '수면 스윗스팟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const TextSpan(text: '과 간단한 루틴을 찾아드립니다.'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 목표 선택
          _buildGoalSelection(),

          const SizedBox(height: 20),

          // 약속 설정
          _buildPromiseSettings(),
        ],
      ),
    );
  }

  Widget _buildGoalSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.teal[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.flag, color: Colors.green[600], size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                '이번 주 목표를 고르세요',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildGoalOption(
            title: '빠르게 잠들기',
            description: '잠드는 시간 10분 단축',
            value: 'fall_asleep_faster',
          ),

          const SizedBox(height: 8),

          _buildGoalOption(
            title: '깊은 수면',
            description: '밤중 깨는 횟수 절반으로',
            value: 'fewer_awakenings',
          ),

          const SizedBox(height: 8),

          _buildGoalOption(
            title: '상쾌한 아침',
            description: '기상 후 피로감 -30%',
            value: 'higher_freshness',
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption({
    required String title,
    required String description,
    required String value,
  }) {
    final isSelected = _selectedGoal == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green[300]! : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green[600] : Colors.grey[400],
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
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromiseSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.indigo[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.settings, color: Colors.blue[600], size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                '미니 약속',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 토글 2개
          _buildToggleOption(
            title: '취침 1시간 전 알림: 준비 시간 확보',
            value: _bedtimeReminder,
            onChanged: (value) {
              setState(() {
                _bedtimeReminder = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildToggleOption(
            title: '아침 10초 체크인: 간단한 기분/수면 기록',
            value: _morningCheckin,
            onChanged: (value) {
              setState(() {
                _morningCheckin = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue[600],
        ),
      ],
    );
  }
}
