import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/signed_in.dart';
import '../screens/home_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    ref.read(signedInProvider.notifier).state = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          InkWell(
              onTap: _signOut,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              ),
            )
        ]),
      body: const Column(
        children: [
          Text(
              'Welcome'
              ),
        ],
      )
    );
  }
}
