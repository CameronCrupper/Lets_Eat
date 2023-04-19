import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../providers/leuser.dart';

import '../models/le_user.dart';

class StartTablePage extends ConsumerStatefulWidget {
  const StartTablePage({Key? key}) : super(key: key);

  @override
  ConsumerState<StartTablePage> createState() => _StartTablePageState();
}

class _StartTablePageState extends ConsumerState<StartTablePage> {
  late LEUser user = ref.watch(leUserProvider);

  final TextEditingController _tablenameController = TextEditingController();

  String _tablename = '';
  final List<dynamic> _attendees = [];
  final List<dynamic> _attendeesNames = [];

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriend(String friend) async {
    final friendInfo = await FirebaseFirestore.instance.collection('users')
      .doc(friend).get();
    return friendInfo;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAttendee(String attendee) {
    final attendeeDoc = FirebaseFirestore.instance.collection('users')
      .doc(attendee).get();
    return attendeeDoc;
  }

  void createTable() async {
    _attendees.add(user.userUid);
    final String tableUid = const Uuid().v1().toString();
    await FirebaseFirestore.instance.collection('tables').doc(tableUid).set({
      'tablename': _tablename,
      'attendees': _attendees,
      'restaurant': {'name':'none'},
      'uid': tableUid
    });
    for (var attendee in _attendees) {
      FirebaseFirestore.instance
        .collection('users').doc(attendee)
        .update({'tables': FieldValue.arrayUnion([tableUid])});
    }
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
              itemCount: user.friends.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: getFriend(user.friends[index]),
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