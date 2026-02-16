import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_riverpod_test/repository/repository.dart';

// 非同期処理の後にrefを参照するパターンのprovider
final hogeProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  ref.read(repositoryProvider).fetch();
  return '処理完了';
});

// retry機能体験Provider
final retryDemoProvider = FutureProvider<String>((ref) async {
  // 試行回数を保持（コンテナ内にキャッシュされる）
  final attempt = ref.read(_attemptProvider.notifier).state++;
  // attempt: 0,1,2,...

  // ログを見たいなら
  // print('attempt=$attempt');

  // 最初の3回は失敗させる
  if (attempt < 3) {
    throw Exception('temporary error (attempt=$attempt)');
  }

  // 4回目以降は成功
  return 'success at attempt=$attempt';
});

// 試行回数カウンタ（デモ用）
final _attemptProvider = StateProvider<int>((ref) => 0);