import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'start_table_page.dart';

class TablesPage extends ConsumerStatefulWidget {
  const TablesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends ConsumerState<TablesPage> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    final currentUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/test.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StartTablePage()));
                        },
                        child: const Text('Start a new Table')),
                    // Expanded(
                    //     child: ListView.builder(
                    //         itemCount:
                    //             snapshot.data!.data()?['tables'].length,
                    //         itemBuilder: (context, index) {
                    //           return Text(
                    //               '${snapshot.data!.data()?['tables'][index]}');
                    //         }))
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
