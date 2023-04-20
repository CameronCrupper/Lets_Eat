import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/le_user.dart';

import '../providers/leuser.dart';

import 'friends_search_page.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  late LEUser currentLEUser = ref.watch(leUserProvider);

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriend(
      String friend) async {
    final friendInfo =
        await FirebaseFirestore.instance.collection('users').doc(friend).get();
    return friendInfo;
  }

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
          children: [
            // Container(
            //   child: Image.asset('assets/images/LetsEatLogo.png',
            //       height: 300, width: 200),
            // ),

            // Theme(
            //   data:
            //       Theme.of(context).copyWith(scaffoldBackgroundColor: Colors.black),
            //   child: Scaffold(),
            // ),
            // Hero(
            //     tag: 'image1',
            //     child: Image.asset('assets/images/Logo1.png')
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FriendSearchPage(),
                  ),
                );
              },
              child: const Text('Find New Friends'),
            ),
            const Text('Here is your list of friends'),
            Expanded(
              child: ListView.builder(
                itemCount: currentLEUser.friends.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: getFriend(currentLEUser.friends[index]),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        // TILE FOR EACH FRIEND IN USER'S LIST

                        return Column(
                          children: <Widget>[
                            // const SizedBox(width: 1),
                            const Divider(
                              height: 25,
                            ),
                            const ListTile(
                              leading: CircleAvatar(
                                radius: 24.0,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  snapshot.data!.data()!['username'],
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            // const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                currentLEUser.friends
                                    .remove(snapshot.data!.data()!['uid']);
                                currentLEUser
                                    .updateFriends(currentLEUser.friends);
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentLEUser.userUid)
                                    .update({'friends': currentLEUser.friends});
                                setState(() {});
                              },
                              child: const Text('Remove Friend'),
                            )
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
