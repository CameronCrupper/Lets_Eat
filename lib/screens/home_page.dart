import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../classes/le_user.dart';
import '../providers/signed_in.dart';
// import '../providers/user_info.dart';
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
      // theme: ThemeData(
      //   primarySwatch: Colors.lightGreen,
      //   // scaffoldBackgroundColor: Colors.transparent,
      // ),
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.lightGreen, backgroundColor: Colors.amber)),
      home: _signedIn ? const ProfilePage() : const LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.lightGreen,
            Colors.lightGreen.shade600,
            Colors.amber,
            Colors.amber.shade600,
          ],
        ),
      ),
      // child: Scaffold(
      //   appBar: AppBar(
      //     title: Icon(Icons.menu),
      //     backgroundColor: Color(0x00000000),
      //     elevation: 0.0,
      //   ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'dummy text',
      //       ),
      // Text(
      //   '5',
      //   style: Theme.of(context).textTheme.display1,
      // ),
      // FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black45,
      //   elevation: 0.0,
      //   onPressed: () {},
      //   tooltip: 'Play',
      //   child: Icon(Icons.play_arrow),
      // ),
      //         ],
      //       ),
    );
    //   ),
    // );
  }
}
