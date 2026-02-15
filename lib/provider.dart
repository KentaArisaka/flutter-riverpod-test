import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/repository/repository.dart';

// 非同期処理の後にrefを参照するパターンのprovider
final hogeProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  ref.read(repositoryProvider).fetch();
  return '処理完了';
});

// Riverpod3でここが動かなくなる原因（Riverpod2では動く）:
// container.read(hogeProvider.future) は「購読(watch/listen)」ではなく一回取得なので、
// autoDispose の hogeProvider は await 中に参照なしと判断されて dispose される。
// dispose 後に provider 内で ref.read(repositoryProvider) を実行すると「破棄済みRefへのアクセス」になり、
// Riverpod3では例外になる（= disposed ref を触れなくなったため）。

// 対策:
// 1) hogeProvider の autoDispose を外す（単発で await して完了させたい用途ならこれが最も簡単）
// 2) autoDispose のままなら ref.keepAlive() を使い、await 中に dispose されないようにする
// 3) read ではなく listen/watch 側で購読を維持する（参照を切らさない）
// 4) どうしても await 後に ref を触るなら、ref.mounted を確認して dispose 済みなら処理を中断する
