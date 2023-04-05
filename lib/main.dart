import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_page.dart';

import 'auth/stub.dart'
  if (dart.library.io) 'auth/android_auth_provider.dart'
  if (dart.library.html) 'auth/web_auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthProvider().initialize();
  runApp(const ProviderScope(
    child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let's Eat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
