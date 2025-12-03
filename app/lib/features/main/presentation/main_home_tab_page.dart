import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import '../../../core/providers/session_provider.dart';
import '../../../di/injection.dart';
import '../../happy_record/domain/usecases/get_records_statistics_usecase.dart';
import '../../happy_record/presentation/home/controllers/home_controller.dart';
import '../../happy_record/presentation/home/intent/home_intent.dart';

class MainHomeTabPage extends ConsumerStatefulWidget {
  const MainHomeTabPage({super.key});

  @override
  ConsumerState<MainHomeTabPage> createState() => _MainHomeTabPageState();
}

class _MainHomeTabPageState extends ConsumerState<MainHomeTabPage>
    with WidgetsBindingObserver {
  late final HomeController _homeController;

  bool _isPageVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeController = HomeController();
    _homeController.addListener(_onStateChanged);
    _homeController.onIntent(LoadRecentRecords());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _homeController.removeListener(_onStateChanged);
    _homeController.dispose();
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

  void _onStateChanged() {
    setState(() {});
  }

  void _refreshData() {
    // 최근 기록 갱신
    _homeController.onIntent(LoadRecentRecords());
    // 통계는 build 메서드에서 매번 계산되므로 setState만 호출하면 됨
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 상단 헤더 섹션
              _buildHeaderSection(isLoggedIn, userName),

              const SizedBox(height: 24),

              // 메인 액션 버튼
              _buildMainActionButton(),

              const SizedBox(height: 24),

              const SizedBox(height: 16),

              // 하단 액션 링크
              _buildSecondaryActionLink(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isLoggedIn, String? userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽 인사말
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '안녕하세요! 🍋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: AppColors.fontWeightMedium,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isLoggedIn ? '오늘도 상큼한 하루 되세요' : '로그인하고 더 많은 기능을 사용해보세요',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),

        // 오른쪽 영역
        if (isLoggedIn)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.ring, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flash_on,
                  color: AppColors.primaryForeground,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '7일',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryForeground,
                    fontWeight: AppColors.fontWeightMedium,
                  ),
                ),
              ],
            ),
          )
        else
          TextButton(
            onPressed: () {
              try {
                context.push('/login');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      '로그인 페이지를 불러올 수 없습니다.',
                      style: TextStyle(color: AppColors.destructiveForeground),
                    ),
                    backgroundColor: AppColors.destructive,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.login, size: 16),
                const SizedBox(width: 4),
                Text(
                  '로그인',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: AppColors.fontWeightMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMainActionButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () async {
          try {
            _isPageVisible = false;
            final result = await context.push('/write');
            _isPageVisible = true;

            // 저장 성공 시 (result == true) 데이터 갱신
            if (result == true) {
              _refreshData();
            }
          } catch (e) {
            _isPageVisible = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  '페이지를 불러올 수 없습니다.',
                  style: TextStyle(color: AppColors.destructiveForeground),
                ),
                backgroundColor: AppColors.destructive,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryForeground,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😊', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              '감정 기록하기',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppColors.fontWeightMedium,
                color: AppColors.primaryForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionLink() {
    return Center(
      child: TextButton(
        onPressed: () async {
          try {
            _isPageVisible = false;
            final result = await context.push('/difficult');
            _isPageVisible = true;

            // 저장 성공 시 (result == true) 데이터 갱신
            if (result == true) {
              _refreshData();
            }
          } catch (e) {
            _isPageVisible = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  '페이지를 불러올 수 없습니다.',
                  style: TextStyle(color: AppColors.destructiveForeground),
                ),
                backgroundColor: AppColors.destructive,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mutedForeground,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😔', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '상세 기록하기',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
                fontWeight: AppColors.fontWeightNormal,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
                decorationColor: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
