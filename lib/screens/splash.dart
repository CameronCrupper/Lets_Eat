import 'package:flutter/material.dart';
import 'package:lets_eat/screens/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.lightGreen.shade600,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo1.png'),
                width: 400,
              ),
              SizedBox(
                height: 50,
              ),
              SpinKitWave(
                color: Colors.orange,
                size: 50.0,
              ),
            ],
          ),
        ),
      );
}

//   _navigateToHome() async {
//     await Future.delayed(Duration(milliseconds: 1500), () {});
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => HomePage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           // children: [
//           //   Container(
//           //     height: 500,
//           //     width: 500,
//           //     color: Colors.blue,
//           //   ),
//           //   Container(
//           //       child: Text('Splash Screen',
//           //           style:
//           //               TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
//           // ],
//         ),
//       ),
//     );
//   }
// }
