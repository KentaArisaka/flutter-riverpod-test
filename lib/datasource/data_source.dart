import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/api/client.dart';

final dataSourceProvider = Provider.autoDispose<DataSource>((ref) {
  return DataSourceImpl(ref);
});

abstract class DataSource {
  Future<Map<String, dynamic>> fetch();
}

class DataSourceImpl implements DataSource {
  const DataSourceImpl(this._ref);

  final Ref _ref;

  ApiClient get _api => _ref.read(apiClientProvider);

  @override
  Future<Map<String, dynamic>> fetch() async => _api.fetch();
}
