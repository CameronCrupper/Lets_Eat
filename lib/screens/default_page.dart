import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_eat/screens/stat_widget.dart';

class DefaultPage extends ConsumerStatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends ConsumerState<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff7cb342), Color(0xffffc107)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
              "Holberton",
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
              "Welcome",
              style: TextStyle(
                color: Colors.black87,
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
                statWidget("Groups", "0"),
                statWidget("Friends", "0"),
                statWidget("Tables", "0"),
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
            Container(
              width: 600,
              height: 265,
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade600,
                border: Border.all(
                  color: Colors.black,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [Colors.lightGreen.shade600, Colors.amber],
                ),
              ),
              child: const SingleChildScrollView(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "How to use Let's Eat!\n",
                        style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text:
                            "1. Enter City, State, and Zipcode on Settings Page\n",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text: "2. Add friends if desired on Friends Page\n",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text:
                            "3. Set your own Preferences for food from 0-10 on the Preferences Page and press Save Preferences\n",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text:
                            "4. Navigate to Tables Page and click Start New Table\n",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text:
                            "5. Name your table, add any Friends you'd like and click Create Table\n",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text:
                            "6. Navigate back to Tables Page and click on your Newly created Tables name\n",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                        text:
                            "7. Click Find a Restaurant and sit back while your meals decided for you!\n",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  // Expanded(
                  //   child: GridView.builder(
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 2,
                  //     ),
                  //     // itemCount: AssetImage.length,
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //         decoration: const BoxDecoration(
                  //           image: DecorationImage(
                  //             image: AssetImage('assets/images/logo1.png'),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
