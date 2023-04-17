import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_eat/providers/user_info.dart';

import 'friends_search_page.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  late List<dynamic> friends = ref.watch(friendsProvider);
  late String uid = ref.watch(uidProvider);

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriend(String friend) async {
    final friendInfo = await FirebaseFirestore.instance.collection('users')
      .doc(friend).get();
    return friendInfo;
  }

  void updateFriends() {
    FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({'friends': friends});
    ref.read(friendsProvider.notifier).updateFriends(friends);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
            tag: 'image1',
            child: Image.asset('assets/images/Logo1.png')
        ),
        ElevatedButton(
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
        const Text('Here is your list of friends'),
        Expanded(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: getFriend(friends[index]),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    // TILE FOR EACH FRIEND IN USER'S LIST
                    return Row(
                      children: [
                        Text(snapshot.data!.data()!['username']),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            friends.remove(snapshot.data!.data()!['uid']);
                            updateFriends();
                            setState(() {});
                          },
                          child: const Text('Remove Friend')
                        )
                      ]
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              );
          })
        )
      ],
    );
  }
}
