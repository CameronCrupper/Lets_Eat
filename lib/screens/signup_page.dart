import 'dart:developer';
import 'package:email_validator/email_validator.dart';
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
  // TEXT FIELD CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // TEXT FIELD CONTENT VARIABLES
  String _email = '';
  String _password = '';
  String _username = '';

  // TEXT FIELD VALIDATION
  bool _emailIsValid = false;
  bool _validateEmail(String value) {
    // Returns false unless value evaluates as true per the
    // EmailValidator plugin
    return EmailValidator.validate(value);
  }

  bool _usernameIsValid = false;
  bool _validateUsername(String value) {
    // Returns false unless the value is at least 3 characters & no more
    // than 20 characters
    if (value.length > 3 && value.length < 21) {
      return true;
    } else {
      return false;
    }
  }

  bool _passwordIsValid = false;
  bool _validatePassword(String value) {
    // Returns false unless value has: 1 capital letter, 1 lower case letter,
    // 1 number, 1 special character, & at least 8 total characters
    if (value.length < 8) return false;
    if (!value.contains(RegExp(r"[a-z]"))) return false;
    if (!value.contains(RegExp(r"[A-Z]"))) return false;
    if (!value.contains(RegExp(r"[0-9]"))) return false;
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // 
  void _addUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
        {
          'uid': user.uid,
          'username': _username,
          'tables': [],
          'preferences': {},
          'friends': []
        }
      );
  }

  void _signUp() async {
    final checkForUser = await FirebaseFirestore.instance.collection('users')
        .doc(_username).get();
    if (checkForUser.data() == null) {
      try {
        AuthProvider().signUpWithEmail(
          _email,
          _password,
        );
      } catch (e) {
        log('User creation failed: $e');
      }
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          await AuthProvider().signInWithEmail(
          _email,
          _password
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
    } else {
      log('Cannot create account: User already exists with that username.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign Up Page"),
      ),
      // SCREEN BODY
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // LOGO BOX
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/Lets-Eat.png')),
              ),
            ),
            // USERNAME TEXT FIELD
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 20, bottom: 10
              ),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username'),
                controller: _usernameController,
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                  _usernameIsValid = _validateUsername(_username);
                },
              ),
            ),
            // USERNAME TEXT INSTRUCTIONS
            Text('Username must be between 3 and 20 characters long',
              style: TextStyle(
                fontSize: 12,
                color: _usernameIsValid ? Colors.green : Colors.red,
              ),
            ),
            // EMAIL TEXT FIELD
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10, bottom: 10
              ),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email'),
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                  _emailIsValid = _validateEmail(_email);
                },
              ),
            ),
            // EMAIL TEXT INSTRUCTIONS
            Text('Email must be valid email format',
              style: TextStyle(
                fontSize: 12,
                color: _emailIsValid ? Colors.green : Colors.red,
              ),
            ),
            // PASSWORD TEXT FIELD
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10, bottom: 10
                ),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                  _passwordIsValid = _validatePassword(_password);
                },
              ),
            ),
            // PASSWORD TEXT INSTRUCTIONS
            Text('''Password must contain; 1 capital letter, 1 lowercase letter,
             1 number,\n1 special character, & be at least 8 characters long''',
              style: TextStyle(
                fontSize: 12,
                color: _passwordIsValid ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            // SIGN UP BUTTON
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: !_usernameIsValid ||
                            !_emailIsValid ||
                            !_passwordIsValid
                            ? Colors.blueGrey
                            : Colors.blue, 
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: _usernameIsValid &&
                             _emailIsValid &&
                             _passwordIsValid
                              ? () {
                                  _signUp();
                                }
                              : () {
                                  // Do nothing
                                },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}