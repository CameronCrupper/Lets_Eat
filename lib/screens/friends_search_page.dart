import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendSearchPage extends ConsumerStatefulWidget {
  const FriendSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends ConsumerState<FriendSearchPage> {
  // final TextEditingController _searchController = TextEditingController();

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    final currentUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return currentUser;
  }

  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    // Column(
    //   children: [Container(height: 120000.0, color: Colors.blue)],
    // );
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
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
                          setState(() {
                            searchValue = value;
                          });
                        }),
                  ),
                ),
                body: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                              ConnectionState.waiting)
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
                                    .startsWith(searchValue.toLowerCase())) {
                                  //this is the visible list of names and add friend button

                                  return Column(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Divider(
                                          height: 12,
                                        ),
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 24.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/avatar.png'),
                                          ),
                                        ),
                                        Row(children: <Widget>[
                                          // Text(data['username']),
                                          SizedBox(width: 16),
                                          Text(
                                            data['username'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]),
                                        // Text(
                                        //   data['username'],
                                        //   maxLines: 1,
                                        //   overflow: TextOverflow.ellipsis,
                                        // ),
                                        ElevatedButton(
                                          child: const Text('Add friend'),
                                          onPressed: () async {
                                            var user = FirebaseAuth
                                                .instance.currentUser;
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .update({
                                              'friends': FieldValue.arrayUnion(
                                                  [data['uid']])
                                            });
                                          },
                                        ),
                                      ]);
                                }
                                // Do not touch V this is magic button!
                                return Container();
                                //no but it pops an invisible container so when there
                                //isnt a successful return it appears to show nothing
                              });
                    }));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
