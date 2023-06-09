import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/start_table_page.dart';
import '../screens/active_table_page.dart';

import '../models/le_user.dart';

import '../providers/leuser.dart';

class TablesPage extends ConsumerStatefulWidget {
  const TablesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends ConsumerState<TablesPage> {
  late LEUser user = ref.watch(leUserProvider);

  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTable(String table) async {
    final tableInfo =
        await FirebaseFirestore.instance.collection('tables').doc(table).get();
    return tableInfo;
  }

  @override
  Widget build(BuildContext context) {
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
            //pushing Start a New Table button down from the top
            const SizedBox(
              height: 350, // height you want
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartTablePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen.shade600,
              ),
              child: const Text('Start a New Table'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: user.tables.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: getTable(user.tables[index]),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        // TILE FOR EACH TABLE IN USER'S LIST
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActiveTablePage(
                                    tableUid: snapshot.data!.data()!['uid']),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                //centerin tablename text
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    snapshot.data!.data()!['tablename'],
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                ),
                                TextButton(
                                  onPressed: () {
                                    user.tables
                                        .remove(snapshot.data!.data()!['uid']);
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.userUid)
                                        .update({'tables': user.tables});
                                    FirebaseFirestore.instance
                                        .collection('tables')
                                        .doc(snapshot.data!.data()!['uid'])
                                        .update(
                                      {
                                        'attendees': FieldValue.arrayRemove(
                                          [user.userUid],
                                        )
                                      },
                                    );
                                    setState(() {});
                                  },
                                  //Leave table custom button
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.lightGreen.shade600,
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(
                                            4,
                                            4,
                                          ),
                                        ),
                                        const BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(
                                            -4,
                                            -4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Leave Table",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        // child: const Text(
                                        //   'Leave Table',
                                        //   style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
