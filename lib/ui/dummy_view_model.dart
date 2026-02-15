import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final dummyViewModelProvider =
    NotifierProvider.autoDispose<DummyViewModel, DummyState>(
      DummyViewModel.new,
    );

class DummyState {
  const DummyState({this.message = ''});

  final String message;
}

class DummyViewModel extends AutoDisposeNotifier<DummyState> {
  @override
  DummyState build() => const DummyState();

  void foo() {
    state = const DummyState(message: '処理完了');
    if (kDebugMode) {
      print('DummyViewModel@foo: 処理完了');
    }
  }
}
