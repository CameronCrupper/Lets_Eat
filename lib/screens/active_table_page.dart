import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/user_info.dart';

class ActiveTablePage extends ConsumerStatefulWidget {
  final String tableUid;
  const ActiveTablePage({Key? key, required this.tableUid}) : super(key: key);

  @override
  ConsumerState<ActiveTablePage> createState() => _ActiveTablePageState();
}

class _ActiveTablePageState extends ConsumerState<ActiveTablePage> {
  late String uid = ref.watch(uidProvider);
  late List<dynamic> tables = ref.watch(tablesProvider);
  late List<dynamic> friends = ref.watch(friendsProvider);

  List<dynamic> _attendees = [];
  String _tableUid = '';
  String _tablename = '';
  Map<String, dynamic> _restaurant = {};

  Future<DocumentSnapshot<Map<String, dynamic>>> getTable(String table) async {
    final tableInfo = await FirebaseFirestore.instance.collection('tables')
      .doc(table).get();
    return tableInfo;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriend(String friend) async {
    final friendInfo = await FirebaseFirestore.instance.collection('users')
      .doc(friend).get();
    return friendInfo;
  }

  void updateAttendees() {
    FirebaseFirestore.instance.collection('tables')
      .doc(_tableUid)
      .update({'attendees': _attendees});
  }  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTable(widget.tableUid),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          _attendees = snapshot.data!.data()!['attendees'];
          _tableUid = snapshot.data!.data()!['uid'];
          _tablename = snapshot.data!.data()!['tablename'];
          _restaurant = snapshot.data!.data()!['restaurant'];
          print(_attendees);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen.shade600,
              leading: const BackButton(),
              title: Text(
                _tablename,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  if (_restaurant['name'] == 'none')
                    ElevatedButton(
                      onPressed: () {
                        // Finding restaurant logic goes here
                      },
                      child: const Text('Find a Restaurant')
                    ),
                  if (_restaurant['name'] != 'none')
                    const Text('restaurant data'),
                  const Text('Attendees:'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _attendees.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: getFriend(_attendees[index]),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Row(
                                children: [
                                  Text('${snapshot.data!.data()!['username']}'),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () {
                                      _attendees.remove(
                                        snapshot.data!.data()!['uid']
                                      );
                                      updateAttendees();
                                      setState(() {});
                                    },
                                    child: const Text('Remove From Table')
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator()
                              );
                            }
                          }
                        );
                      }
                    )
                  ),
                ]
              )
            )
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}