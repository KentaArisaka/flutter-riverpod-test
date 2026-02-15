import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider.autoDispose<ApiClient>((ref) {
  return ApiClientImpl();
});

abstract class ApiClient {
  Future<Map<String, dynamic>> fetch();
}

class ApiClientImpl implements ApiClient {
  @override
  Future<Map<String, dynamic>> fetch() async {
    await Future.delayed(Duration(milliseconds: 500));
    return {'id': 1, 'username': 'hoge'};
  }
}
