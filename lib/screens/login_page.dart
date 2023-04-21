import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_eat/screens/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../default_data/preferences.dart';
import '../providers/signed_in.dart';
import '../auth/stub.dart'
    if (dart.library.io) '../auth/android_auth_provider.dart'
    if (dart.library.html) '../auth/web_auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginPage> {
  //  TEXT FIELD CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _addUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': 'anonymous_${user.uid.substring(0, 6)}',
        'tables': [],
        'preferences': defaultPreferences,
        'friends': [],
        'city': '',
        'state': '',
        'zip': ''
      });
    }
  }

  void _googleSignIn() async {
    try {
      await AuthProvider().signInWithGoogle();
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      var checkForUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      if (checkForUser.data() == null) {
        _addUser();
      }
    } catch (e) {
      log('Login Failed: $e');
    }
  }

  void _emailSignIn() async {
    try {
      await AuthProvider().signInWithEmail(
          _emailController.text.trim(), _passwordController.text.trim());
      ref.read(signedInProvider.notifier).state = true;
    } catch (e) {
      log('Login Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade600,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/LetsEatLogo.png'),
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email',
                ),
                controller: _emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15,
                bottom: 0,
              ),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter password',
                ),
                controller: _passwordController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New User?  ',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                InkWell(
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _emailSignIn();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 10
            ),
            // GOOGLE SIGN IN BUTTON
            SignInButton(
              Buttons.Google,
              padding: const EdgeInsets.all(15),
              onPressed: _googleSignIn,
            ),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
