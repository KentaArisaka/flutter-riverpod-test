import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/repository/repository.dart';

// 非同期処理の後にrefを参照するパターンのprovider
final hogeProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  ref.read(repositoryProvider).fetch();
  return '処理完了';
});

int _attempt = 0;

// retry機能体験Provider
final retryDemoProvider = FutureProvider<String>((ref) async {
  // 試行回数を保持（コンテナ内にキャッシュされる）
  _attempt++;
  // attempt: 0,1,2,...

  if (kDebugMode) {
    print('attempt=$_attempt');
  }

  await Future.delayed(Duration(seconds: 2));

  // 最初の3回は失敗させる
  if (_attempt < 3) {
    if (kDebugMode) {
      print('temporary error (attempt=$_attempt)');
    }

    throw Exception('temporary error (attempt=$_attempt)');
  }

  if (kDebugMode) {
    print('success at attempt=$_attempt');
  }

  // 4回目以降は成功
  return 'success at attempt=$_attempt';
});
