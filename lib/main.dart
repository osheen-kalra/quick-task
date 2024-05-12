// main.dart
import 'package:flutter/material.dart';
import 'package:quicktask_app/screens/login_screen.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Parse().initialize(
    'H9hLC89uGxubJKavksXtlULYAaIHcNbi8HWlUb4J',
    'https://parseapi.back4app.com/',
    clientKey: 'ZseTP05bPZUibe32iR17ckJ55qCK0g8rXGt9K9Xf',
    autoSendSessionId: true,
    debug: true,
  );
  runApp(const QuickTaskApp());
}

class QuickTaskApp extends StatelessWidget {
  const QuickTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
