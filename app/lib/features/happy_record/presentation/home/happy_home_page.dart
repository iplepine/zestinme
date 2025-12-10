import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/app/routes/app_router.dart';
import 'package:zestinme/shared/services/quote_service.dart';

import 'controllers/home_controller.dart';
import 'intent/home_intent.dart';
import 'widgets/draggable_fab.dart';
import 'widgets/drag_gesture_handler.dart';
import 'widgets/home_content.dart';
import 'widgets/score_slider.dart';

class HappyHomePage extends StatelessWidget {
  const HappyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {
  late final HomeController _controller;
  bool _shouldScrollToTop = false;
  bool _isPageVisible = true;

  // --- 명언 ---
  late final QuoteService _quoteService;
  late final Map<String, String> _dailyQuote;

  // --- 오버레이 및 제스처 상태 ---
  int _sliderScore = 4;
  final double _sliderWidth = 220;
  bool _isDragging = false; // 현재 드래그/선택 중인지 상태

  // --- 애니메이션 상태 ---
  final GlobalKey _fabKey = GlobalKey(); // FAB 위치 추적용
  late final DragGestureHandler _dragHandler;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = HomeController();
    _controller.addListener(_onStateChanged);
    _controller.onIntent(LoadRecentRecords());

    _quoteService = QuoteService();
    _dailyQuote = _quoteService.getQuoteOfTheDay();

    _dragHandler = DragGestureHandler(
      sliderWidth: _sliderWidth,
      onScoreChanged: (score) {
        setState(() {
          _sliderScore = score;
        });
      },
      onDragEnd: _handleDragEnd,
      fabKey: _fabKey,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 포그라운드로 돌아올 때 갱신
    if (state == AppLifecycleState.resumed && _isPageVisible) {
      _refreshData();
    }
  }

  void _onStateChanged() => setState(() {});

  void _refreshData() {
    _controller.onIntent(LoadRecentRecords());
  }

  void _goToWritePage(BuildContext context, int score) async {
    _isPageVisible = false;
    // Navigate to Seeding Screen (The new Emotion Write)
    // We ignore 'score' as Seeding starts with its own flow.
    await context.push(AppRouter.seeding);

    _isPageVisible = true;

    // Always refresh when returning from Seeding, assuming user might have added something
    if (context.mounted) {
      setState(() {
        _shouldScrollToTop = true;
      });
      _refreshData();
    }
  }

  // --- Gesture Handling ---
  void _handleDragStart(Offset startPosition) {
    final fabRenderBox =
        _fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (fabRenderBox == null) return;

    final fabRect = fabRenderBox.localToGlobal(Offset.zero) & fabRenderBox.size;

    // FAB 영역에서 드래그가 시작되었는지 확인
    if (fabRect.contains(startPosition)) {
      setState(() {
        _isDragging = true;
      });
      _dragHandler.handleDragStart(startPosition);
    }
  }

  void _handleDragUpdate(Offset currentPosition) {
    if (!_isDragging) return;
    _dragHandler.handleDragUpdate(currentPosition);
  }

  void _handleDragEnd() {
    if (!_isDragging) return;

    // 드래그가 끝나면 항상 점수와 함께 쓰기 페이지로 이동
    _goToWritePage(context, _sliderScore);

    setState(() {
      _isDragging = false;
      _sliderScore = 3; // 기본값으로 리셋
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // 화면 전체의 탭을 감지하여 드래그 취소
    return GestureDetector(
      onTap: () {
        // 드래그 중이 아닐 때 탭하면 취소
        if (_isDragging) {
          setState(() {
            _isDragging = false;
            _sliderScore = 3;
          });
        }
      },
      // Scaffold의 배경을 터치해도 onTap이 감지되도록 동작 설정
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('해피 인사이드'),
          centerTitle: true,
          elevation: 0,
        ),
        // Stack을 사용하여 위젯들을 겹치게 함
        body: Stack(
          children: [
            // --- 기본 UI ---
            Positioned.fill(
              child: HomeContent(
                recentRecords: state.recentRecords,
                dailyQuote: _dailyQuote,
                shouldScrollToTop: _shouldScrollToTop,
                onDidScrollToTop: () {
                  setState(() {
                    _shouldScrollToTop = false;
                  });
                },
              ),
            ),

            // --- FAB ---
            // Positioned를 사용하여 FAB를 화면 하단 중앙에 배치
            Positioned(
              bottom: 32 + bottomPadding, // 하단 패딩 적용
              left: 0,
              right: 0,
              child: DraggableFAB(
                selectedScore: _sliderScore,
                isDragging: _isDragging,
                fabKey: _fabKey,
                onDragStart: _handleDragStart,
                onDragUpdate: _handleDragUpdate,
                onDragEnd: _handleDragEnd,
              ),
            ),

            // --- Score Slider (오버레이) ---
            if (_isDragging)
              Positioned(
                bottom: 32 + bottomPadding, // 하단 패딩 적용
                left: 0,
                right: 0,
                child: Center(
                  child: ScoreSlider(
                    score: _sliderScore,
                    sliderWidth: _sliderWidth,
                    opacity: const AlwaysStoppedAnimation(1), // 항상 표시
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
