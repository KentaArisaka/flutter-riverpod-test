import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/repository/repository.dart';

// 非同期処理の後にrefを参照するパターンのprovider
final hogeProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  ref.read(repositoryProvider).fetch();
  return '処理完了';
});
