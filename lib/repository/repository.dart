import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/datasource/data_source.dart';
import 'package:flutter_riverpod_test/repository/result.dart';

// Ref注入パターン
final repositoryProvider = Provider.autoDispose<Repository>((ref) {
  return RepositoryImpl(ref);
});

abstract class Repository {
  Future<Result> fetch();
}

class RepositoryImpl implements Repository {
  const RepositoryImpl(this._ref);

  final Ref _ref;

  DataSource get _ds => _ref.read(dataSourceProvider);

  // 非同期処理の後にrefにアクセスする想定
  @override
  Future<Result> fetch() async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await _ds.fetch();

    return Result(
      id: response['id'] as int,
      username: response['username'] as String,
    );
  }
}

// Riverpod3でここが動かなくなる原因（Riverpod2では動く）:
// このRepositoryは Ref をフィールド保持しており、await の後に getter(_ds) 経由で _ref.read(...) を実行する。
// repositoryProvider は autoDispose のため、await 中に「参照がない」と判断されて provider の世代が dispose され得る。
// dispose 済みの provider 世代に紐づく Ref を使って _ref.read(...) すると「破棄済みRefへのアクセス」となり、
// Riverpod3では例外になる（dispose後の Ref/Notifier 操作が厳密化されたため）。

// 対策（どれか一つ、もしくは組み合わせ）:
// 1) Ref をクラスに注入しない：provider側で依存（DataSource/ApiClient等）を解決して注入する（推奨）
//    例: final repositoryProvider = Provider.autoDispose((ref) => RepositoryImpl(ref.watch(dataSourceProvider)));
// 2) autoDispose を外す / keepAlive する：参照が切れても dispose されないようにする
//    例: Provider<Repository> にする、または provider内で ref.keepAlive() を使う
// 3) await の後に ref を触らない：必要な依存は await 前に取得してローカル変数に保持して使う
//    例: final ds = _ref.read(dataSourceProvider); await ...; await ds.fetch();
// 4) どうしても await 後に触る必要があるなら、生存確認して中断する（Notifier/AsyncNotifierなら ref.mounted 等）
//    ※ただし Repository のような“ref保持クラス”だと設計的に根本解決になりにくいので 1) が最優先
