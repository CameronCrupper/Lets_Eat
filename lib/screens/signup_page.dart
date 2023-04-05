import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_eat/screens/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/signed_in.dart';
import '../auth/stub.dart'
  if (dart.library.io) '../auth/android_auth_provider.dart'
  if (dart.library.html) '../auth/web_auth_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpPage> {
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
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'username': 'anonymous',
          'tables': [],
          'cuisines': [],
        }
      );
    }
  }

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    try {
      AuthProvider().signUpWithEmail(
        email,
        password
      );
    } catch (e) {
      log('User creation failed: $e');
    }
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        await AuthProvider().signInWithEmail(
        email,
        password
        );
      } catch (e) {
        log('Login failed: $e');
      }
      ref.read(signedInProvider.notifier).state = true;
      _addUser();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage()
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign Up Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/Lets-Eat.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const  EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email'),
                    controller: _emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
                    controller: _passwordController,
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  _signUp();
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
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