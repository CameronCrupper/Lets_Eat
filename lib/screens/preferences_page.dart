import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../default_data/preferences.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    final currentUser = await FirebaseFirestore.instance.collection('users')
      .doc(user!.uid).get();
    return currentUser;
  }

  void _updatePreference(String key, int value) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users')
      .doc(user!.uid).update({'preferences.$key': value});
  }

  List defaultValueList = emptyValueList;
  List defaultKeyList = preferencesList;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        Map userPrefs = snapshot.data!.data()?['preferences'];
        var sortedUserPrefs = Map.fromEntries(
          userPrefs.entries.toList()..sort(
            (a, b) => a.key.compareTo(b.key)
          )
        );
        for (int x = 0; x < sortedUserPrefs.length; x++) {
          defaultValueList[x] = sortedUserPrefs.values.elementAt(x);
        }
        if (snapshot.data != null) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                itemCount: snapshot.data!.data()?['preferences'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 200,
                          child: Text(preferencesList[index]),
                        ),
                        Slider(
                          value: defaultValueList[index],
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            setState(() {
                              defaultValueList[index] = value.toInt();
                            });
                            _updatePreference(
                              defaultKeyList[index],
                              value.toInt()
                            );
                          },
                        ),
                        Text('${defaultValueList[index]}')
                      ],
                    )
                  );
                })
              )
            ],
          );
        } else {
          return  const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  } 
}