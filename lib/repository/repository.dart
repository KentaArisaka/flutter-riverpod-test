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

  @override
  Future<Result> fetch() async {
    final response = await _ds.fetch();

    return Result(
      id: response['id'] as int,
      username: response['username'] as String,
    );
  }
}
