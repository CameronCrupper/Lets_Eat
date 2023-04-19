import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_eat/screens/stat_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_eat/providers/user_info.dart';

class DefaultPage extends ConsumerStatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends ConsumerState<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 56,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "User",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // Text(
            //   "User",
            //   style: TextStyle(
            //     color: Colors.pink,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            // ),
            // ),
            const Text(
              "@therealone",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                statWidget("Groups", "1"),
                statWidget("Friends", "1"),
                statWidget("Tables", "7"),
                // Expanded(
                //   child: Column(
                //     children: [
                //       Text(
                //         "Followers",
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 18,
                //         ),
                //       ),
                //       Text(
                //         "1",
                //         style: TextStyle(
                //           fontSize: 16,
                //           color: Colors.black,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  // style: ButtonStyle(
                  //   overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  //       (Set<MaterialState> states) {
                  //     // if (states.contains(MaterialState.focused))
                  //     //   return Colors.red;
                  //     // if (states.contains(MaterialState.hovered))
                  //     //     return Colors.green;
                  //     if (states.contains(MaterialState.pressed))
                  //       return Colors.white10;
                  //     return null;
                  //     // Defer to the widget's default.
                  //   }),
                  // ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.lightGreen.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: const Text('Follow'),
                  // color: Colors.black,
                  // child: Text(
                  //   "Follow",
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                ),
                const SizedBox(
                  width: 12,
                ),
                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.lightGreen.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                  ),
                  child: const Text("Message"),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                height: 18,
                thickness: 0.6,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                // itemCount: AssetImage.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo1.png')),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
