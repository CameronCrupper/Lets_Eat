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
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
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
            Text(
              "@therealone",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            SizedBox(
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
            SizedBox(
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

                  child: Text('Follow'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.lightGreen.shade600,
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  // color: Colors.black,
                  // child: Text(
                  //   "Follow",
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                ),
                SizedBox(
                  width: 12,
                ),
                TextButton(
                  child: Text("Message"),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.lightGreen.shade600,
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 18,
                thickness: 0.6,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  // itemCount: AssetImage.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo1.png')),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
