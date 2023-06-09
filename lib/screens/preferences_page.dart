import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/le_user.dart';

import '../default_data/preferences.dart';

import '../providers/leuser.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  late LEUser user = ref.watch(leUserProvider);

  List defaultValueList = emptyValueList;
  List defaultKeyList = preferencesList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff7cb342), Color(0xffffc107)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.userUid)
                    .update({'preferences': user.preferences});
              },
              child: const Text(
                'Save preferences',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: user.preferences.length,
                itemBuilder: (context, index) {
                  final prefKey = user.preferences.keys.elementAt(index);
                  final prefValue = user.preferences.values.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 200,
                          child: Text(prefKey),
                        ),
                        Slider(
                          activeColor: Colors.green.shade700,
                          inactiveColor: Colors.white54,
                          value: prefValue,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            setState(
                              () {
                                user.preferences[prefKey] = value.toInt();
                              },
                            );
                          },
                        ),
                        Text('${user.preferences[prefKey]}')
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
