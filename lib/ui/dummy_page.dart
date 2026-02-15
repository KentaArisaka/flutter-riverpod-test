import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import './dummy_view_model.dart';

class DummyPage extends ConsumerWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dummyViewModelProvider.notifier);
    final state = ref.watch(dummyViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dummy Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),

            const SizedBox(height: 8),

            Text('戻るボタンを押した時の挙動'),

            const SizedBox(height: 16),

            Text('Riverpod 2 -> 動く'),
            Text('Riverpod 3 -> 例外発生'),

            const SizedBox(height: 8),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(seconds: 1));
                  notifier.foo();
                },
                child: const Text('戻る'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
