import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_provider_base.dart';

class _AndroidAuthProvider implements AuthProviderBase {
  @override
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyANlM9gAtlLGtVojjMF81eyEc8zZE0NMWY",
        authDomain: "let-s-eat-ab2de.firebaseapp.com",
        projectId: "let-s-eat-ab2de",
        storageBucket: "let-s-eat-ab2de.appspot.com",
        messagingSenderId: "260199676239",
        appId: "1:260199676239:android:6bbd944852a98f339d2d3a"
      )
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
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

class AuthProvider extends _AndroidAuthProvider {}
