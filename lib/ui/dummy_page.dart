import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/provider.dart';

class DummyPage extends ConsumerWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dummy Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Riverpod 3 Retry Demo:'),
            ref
                .watch(retryDemoProvider)
                .when(
                  data: (data) => Text(
                    'Status: $data',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  error: (err, stack) => Text(
                    'Status: Error - $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                  loading: () => const CircularProgressIndicator(),
                ),
          ],
        ),
      ),
    );
  }
}
