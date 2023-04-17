import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_eat/providers/user_info.dart';

import 'start_table_page.dart';

class TablesPage extends ConsumerStatefulWidget {
  const TablesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends ConsumerState<TablesPage> {
  late String uid = ref.watch(uidProvider);
  late List<dynamic> tables = ref.watch(tablesProvider);

  Future<DocumentSnapshot<Map<String, dynamic>>> getTable(String table) async {
    final tableInfo = await FirebaseFirestore.instance.collection('tables')
      .doc(table).get();
    return tableInfo;
  }

  void updateTables() {
    FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({'tables': tables});
    ref.read(tablesProvider.notifier).updateTables(tables);
  }

  @override
  Widget build(BuildContext context) {
    print('Tables: $tables');
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StartTablePage()
              )
            );
          },
          child: const Text('Start a new table')
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
                    return Row(
                      children: [
                        Text(snapshot.data!.data()!['uid']),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            tables.remove(snapshot.data!.data()!['uid']);
                            updateTables();
                            // Enter logic for removing user from table's list of attendees
                            setState(() {});
                          },
                          child: const Text('Leave Table')
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
        ),
      ],
    );
  }
}