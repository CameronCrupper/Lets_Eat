import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'friends_search_page.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(height: 300, color: Colors.black);
//   }
// }

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    final currentUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return currentUser;
  }

  // Future<List<String>> getUserFriends() async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   List<String> friendList = [];
  //   final user = FirebaseAuth.instance.currentUser;
  //   final currentUser = await FirebaseFirestore.instance.collection('users')
  //     .doc(user!.uid).get();
  //   for (var friend in currentUser.data()!['friends']) {
  //     final currentFriend = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(friend).get();
  //     friendList.add(
  //       currentFriend.data()!['username']
  //     );
  //   }
  //   return friendList;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: [
                Hero(
                    tag: 'image1',
                    child: Image.asset('assets/images/Logo1.png')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendSearchPage()));
                    },
                    child: const Text('Find New Friends')),
                // Container(
                //   height: 285,
                //   color: Colors.red,
                // ),
                Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.data()?['friends'].length,
                        itemBuilder: (context, index) {
                          // return ListTile(
                          //   title: Text(snapshot.data![index]['title']),
                          //   subtitle: Text(snapshot.data![index]['desc']),
                          // );
                          return Text(
                              '${snapshot.data!.data()?['friends'][index]}');
                        }))
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
