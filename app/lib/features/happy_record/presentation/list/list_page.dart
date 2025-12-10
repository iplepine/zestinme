import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/app/routes/app_router.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('행복 기록 목록')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('행복 기록 작성하기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () {
                  context.push(AppRouter.seeding);
                },
              ),
            ),
          ),
          // TODO: 실제 기록 목록 위젯 추가
          const Expanded(child: Center(child: Text('아직 기록이 없습니다.'))),
        ],
      ),
    );
  }
}
