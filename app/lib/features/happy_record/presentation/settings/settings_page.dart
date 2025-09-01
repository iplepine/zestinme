import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/session_provider.dart';
import '../../../anger/presentation/test_firebase_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(
                '설정',
                style: TextStyle(
                  fontWeight: AppColors.fontWeightMedium,
                  color: AppColors.foreground,
                ),
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 로그인 상태 표시
                  if (isLoggedIn)
                    _SettingsSection(
                      title: '계정',
                      items: [
                        _SettingsItem(
                          icon: Icons.person,
                          title: '프로필 설정',
                          subtitle: '${userName ?? '사용자'}님의 프로필',
                          onTap: () {
                            // 프로필 설정 페이지로 이동
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.logout,
                          title: '로그아웃',
                          subtitle: '계정에서 로그아웃',
                          onTap: () async {
                            // 로그아웃 확인 다이얼로그
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('로그아웃'),
                                content: const Text('정말 로그아웃하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.destructive,
                                    ),
                                    child: const Text('로그아웃'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldLogout == true) {
                              await ref.read(sessionProvider).logout();
                              if (context.mounted) {
                                context.go('/');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('로그아웃되었습니다.'),
                                    backgroundColor: AppColors.accent,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          isDestructive: true,
                        ),
                      ],
                    )
                  else
                    _SettingsSection(
                      title: '계정',
                      items: [
                        _SettingsItem(
                          icon: Icons.login,
                          title: '로그인',
                          subtitle: '계정에 로그인',
                          onTap: () {
                            context.push('/login');
                          },
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // 알림 설정
                  _SettingsSection(
                    title: '알림',
                    items: [
                      _SettingsItem(
                        icon: Icons.notifications,
                        title: '알림 설정',
                        subtitle: '푸시 알림 관리',
                        onTap: () {
                          // 알림 설정 페이지로 이동
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 데이터 관리
                  _SettingsSection(
                    title: '데이터',
                    items: [
                      _SettingsItem(
                        icon: Icons.download,
                        title: '데이터 내보내기',
                        subtitle: '기록 데이터를 파일로 저장',
                        onTap: () {
                          // 데이터 내보내기
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.delete,
                        title: '데이터 삭제',
                        subtitle: '모든 기록 데이터 삭제',
                        onTap: () {
                          // 데이터 삭제 확인 다이얼로그
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 앱 정보
                  _SettingsSection(
                    title: '앱 정보',
                    items: [
                      _SettingsItem(
                        icon: Icons.info,
                        title: '버전 정보',
                        subtitle: 'v1.0.0',
                        onTap: () {
                          // 버전 정보 표시
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.privacy_tip,
                        title: '개인정보 처리방침',
                        subtitle: '개인정보 수집 및 이용 안내',
                        onTap: () {
                          // 개인정보 처리방침 페이지로 이동
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.description,
                        title: '이용약관',
                        subtitle: '서비스 이용 약관',
                        onTap: () {
                          // 이용약관 페이지로 이동
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Firebase 테스트 (개발용)
                  _SettingsSection(
                    title: '개발자 도구',
                    items: [
                      _SettingsItem(
                        icon: Icons.cloud,
                        title: 'Firebase 연결 테스트',
                        subtitle: 'Firebase 서비스 연결 상태 확인',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TestFirebasePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 지원
                  _SettingsSection(
                    title: '지원',
                    items: [
                      _SettingsItem(
                        icon: Icons.help,
                        title: '도움말',
                        subtitle: '자주 묻는 질문',
                        onTap: () {
                          // 도움말 페이지로 이동
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.email,
                        title: '문의하기',
                        subtitle: '개발팀에게 문의',
                        onTap: () {
                          // 문의하기 페이지로 이동
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: AppColors.fontWeightMedium,
              color: AppColors.foreground,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(children: items.map((item) => item).toList()),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.destructive : AppColors.primary,
          size: 20,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: AppColors.fontWeightMedium,
            color: isDestructive ? AppColors.destructive : AppColors.foreground,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.mutedForeground,
        ),
        onTap: onTap,
      ),
    );
  }
}
