import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'friends_search_page.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    final currentUser = await FirebaseFirestore.instance.collection('users')
      .doc(user!.uid).get();
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FriendSearchPage()
                    )
                  );
                }, 
                child: const Text('Find New Friends')
              ),
              Expanded(
                child: ListView.builder(
                itemCount: snapshot.data!.data()?['friends'].length,
                itemBuilder: (context, index) {
                  return Text('${snapshot.data!.data()?['friends'][index]}');
                })
              )
            ],
          );
        } else {
          return  const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  } 
}