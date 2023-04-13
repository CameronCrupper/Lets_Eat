import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/signed_in.dart';
import '../screens/login_page.dart';
import '../screens/profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late bool _signedIn = ref.watch(signedInProvider);

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user is User) {
        ref.read(signedInProvider.notifier).state = true;
        _signedIn = ref.watch(signedInProvider);
      } else {
        ref.read(signedInProvider.notifier).state = false;
        _signedIn = ref.watch(signedInProvider);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _signedIn ? const ProfilePage() : const LoginPage(),
    );
  }
}
