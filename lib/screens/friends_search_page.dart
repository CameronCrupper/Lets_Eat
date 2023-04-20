import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/le_user.dart';

import '../providers/leuser.dart';

class FriendSearchPage extends ConsumerStatefulWidget {
  const FriendSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends ConsumerState<FriendSearchPage> {
  late LEUser user = ref.watch(leUserProvider);

  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    // Column(
    //   children: [Container(height: 120000.0, color: Colors.blue)],
    // );
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
              ),
              onChanged: (value) {
                setState(
                  () {
                    searchValue = value;
                  },
                );
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      if (data['username']
                              .toString()
                              .toLowerCase()
                              .startsWith(searchValue.toLowerCase()) &&
                          (data['username'] != user.username) &&
                          (!user.friends.contains(data['uid']))) {
                        //this is the visible list of names and add friend button
                        return Column(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.center,
                          // crossAxisAlignment:
                          //     CrossAxisAlignment.center,
                          children: <Widget>[
                            const Divider(
                              height: 12,
                            ),
                            const ListTile(
                              leading: CircleAvatar(
                                radius: 24.0,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                // Text(data['username']),
                                const SizedBox(width: 16),
                                Text(
                                  data['username'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            // Text(
                            //   data['username'],
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            ElevatedButton(
                              child: const Text('Add friend'),
                              onPressed: () async {
                                user.friends.add(data['uid']);
                                user.updateFriends(user.friends);
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.userUid)
                                    .update({'friends': user.friends});
                                setState(() {});
                              },
                            ),
                          ],
                        );
                      }
                      // Do not touch V this is magic button!
                      return Container();
                      //no but it pops an invisible container so when there
                      //isnt a successful return it appears to show nothing
                    },
                  );
          },
        ));
  }
}
