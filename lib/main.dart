import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod_test/provider.dart';
import 'package:flutter_riverpod_test/repository/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final result = await container.read(repositoryProvider).fetch();
  final message = await container.read(hogeProvider.future);

  if (kDebugMode) {
    print(message);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(id: result.id, username: result.username),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.id, required this.username, super.key});

  final int id;
  final String username;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('ID: $id'), Text('Username: $username')],
            ),
          ),
        ),
      ),
    );
  }
}
