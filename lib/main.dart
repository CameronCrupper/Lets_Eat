// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash.dart';
// import 'screens/home_page.dart';

import 'auth/stub.dart'
    if (dart.library.io) 'auth/android_auth_provider.dart'
    if (dart.library.html) 'auth/web_auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthProvider().initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let's Eat",
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // https://pub.dev/packages/animated_splash_screen/example
      // documentation for using animation on splash screen
//       home: AnimatedSplashScreen(
//         // splash: Image.asset(
//         //   'assets/images/Logo.png',
//         // ),
//         // duration: 3000,
//         // splashTransition: SplashTransition.fadeTransition,
//         // backgroundColor: Colors.lightGreen.shade600,
//         // nextScreen: const HomePage()),
//         splash: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // container for image to be used
//               SingleChildScrollView(
//                 child: Image.asset(
//                   'assets/images/Logo1.png',
//                   height: 500,
//                   width: 500,
//                 ),
//                 // height: 500,
//                 // width: 500,
//                 // color: Colors.blue,
//               ),
//               //can be removed or changed if needed
//               // Container(
//               //     child: Text('Splash Screen',
//               //         style: TextStyle(
//               //             fontSize: 24, fontWeight: FontWeight.bold))),
//             ],
//           ),
//         ),
//         nextScreen: HomePage(),
//       ),
    );
  }
}
