import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/user_info.dart';
import 'start_table_page.dart';
import 'active_table_page.dart';

class TablesPage extends ConsumerStatefulWidget {
  const TablesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends ConsumerState<TablesPage> {
  late String uid = ref.watch(uidProvider);
  late List<dynamic> tables = ref.watch(tablesProvider);

  Future<DocumentSnapshot<Map<String, dynamic>>> getTable(String table) async {
    final tableInfo =
        await FirebaseFirestore.instance.collection('tables').doc(table).get();
    return tableInfo;
  }

  void updateTables() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'tables': tables});
    ref.read(tablesProvider.notifier).updateTables(tables);
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
                        builder: (context) => const StartTablePage()));
              },
              child: const Text('Start a New Table'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen.shade600,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: getTable(tables[index]),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        // TILE FOR EACH TABLE IN USER'S LIST
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActiveTablePage(
                                        tableUid:
                                            snapshot.data!.data()!['uid'])));
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
                                const SizedBox(height: 20, width: 20),
                                TextButton(
                                  onPressed: () {
                                    tables
                                        .remove(snapshot.data!.data()!['uid']);
                                    updateTables();
                                    // Enter logic for removing user from table's list of attendees
                                    setState(() {});
                                  },
                                  //Leave table custom button
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.lightGreen.shade600,
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(4, 4),
                                        ),
                                        const BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(-4, -4),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Leave Table",
                                        style: TextStyle(color: Colors.black),
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
