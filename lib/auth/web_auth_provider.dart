import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_provider_base.dart';

class _WebAuthProvider implements AuthProviderBase {
  @override
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyANlM9gAtlLGtVojjMF81eyEc8zZE0NMWY",
        authDomain: "let-s-eat-ab2de.firebaseapp.com",
        projectId: "let-s-eat-ab2de",
        storageBucket: "let-s-eat-ab2de.appspot.com",
        messagingSenderId: "260199676239",
        appId: "1:260199676239:web:e2773c3b6819456e9d2d3a"
      )
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider();

    provider.addScope('https://www.googleapis.com/auth/userinfo.email');
    provider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    provider.setCustomParameters({
      'prompt': 'select_account',
      'login_hint': 'user@example.com'});
    return await FirebaseAuth.instance.signInWithPopup(provider);
  }

  @override
  Future<UserCredential> signInWithEmail(email, password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  @override
  Future<UserCredential> signUpWithEmail(email, password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
  }
}

class AuthProvider extends _WebAuthProvider {}