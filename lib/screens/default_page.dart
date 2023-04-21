import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/stat_widget.dart';

import '../models/le_user.dart';

import '../providers/leuser.dart';

class DefaultPage extends ConsumerStatefulWidget {
  const DefaultPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends ConsumerState<DefaultPage> {
  late LEUser user = ref.watch(leUserProvider);

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
              "Welcome!",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            Text(
              user.username,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (user.userCity == '' || 
                    user.userState == '' ||
                    user.userZip == '')
                  statWidget("Location", "no location set"),
                if (user.userCity != '' &&
                    user.userState != '' &&
                    user.userZip != '')
                  statWidget("Location",
                             "${user.userCity}, ${user.userState} ${user.userZip}"),
                statWidget("Friends", "${user.friends.length}"),
                statWidget("Tables", "${user.tables.length}"),
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
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
