import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../providers/user_info.dart';

class StartTablePage extends ConsumerStatefulWidget {
  const StartTablePage({Key? key}) : super(key: key);

  @override
  ConsumerState<StartTablePage> createState() => _StartTablePageState();
}

class _StartTablePageState extends ConsumerState<StartTablePage> {
  late List<dynamic> tables = ref.watch(tablesProvider);
  late List<dynamic> friends = ref.watch(friendsProvider);
  late String uid = ref.watch(uidProvider);

  final TextEditingController _tablenameController = TextEditingController();

  String _tablename = '';
  final List<dynamic> _attendees = [];
  final List<dynamic> _attendeesNames = [];

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriend(String friend) async {
    final friendInfo = await FirebaseFirestore.instance.collection('users')
      .doc(friend).get();
    return friendInfo;
  }

  void createTable() async {
    final String tableUid = const Uuid().v1().toString();
    final checkForTable = await FirebaseFirestore.instance
      .collection('tables')
      .where('tablename', isEqualTo: _tablename)
      .get();
    if (checkForTable.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('tables').doc(tableUid).set({
        'tablename': _tablename,
        'attendees': _attendees,
        'restaurant': {'name':'none'},
        'uid': tableUid
      });
      tables.add(tableUid);
      updateTables();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('That Table name is already taken'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                 child: const Text('Dismiss'))
            ],
          );
        },
      );
      log('Cannot create table: Table already exists with that tablename.');
    }
  }

  void updateTables() {
    FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({'tables': tables});
    ref.read(tablesProvider.notifier).updateTables(tables);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('New Table')
      ),
      body: Column(
        children: <Widget>[
          // TABLENAME TEXT FIELD
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 20, bottom: 10),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Table Name',
                  hintText: 'Enter a name for your table'),
              controller: _tablenameController,
              onChanged: (value) {
                setState(() {
                  _tablename = value;
                });
              },
            ),
          ),
          Text('Invited: $_attendeesNames'),
          // SIGN UP BUTTON
          ElevatedButton(
            onPressed: () {
              createTable();
            },
            child: const Text('Create Table')
          ),
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
                              _attendees.add(snapshot.data!.data()!['uid']);
                              _attendeesNames.add(
                                snapshot.data!.data()!['username']
                              );
                              setState(() {});
                            },
                            child: const Text('Add Friend to Table')
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
      )
    );
  } 
}