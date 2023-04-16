import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../default_data/preferences.dart';
import '../providers/user_info.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  late Map<String, dynamic> preferences = ref.watch(preferencesProvider);
  late String uid = ref.watch(uidProvider);

  void _updatePreference() {
    FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .set({'preferences': preferences});
    ref.read(preferencesProvider.notifier).updatePreferences(preferences);
  }

  List defaultValueList = emptyValueList;
  List defaultKeyList = preferencesList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            _updatePreference();
          },
          child: const Text(
            'Save preferences'
          )),
        Expanded(
          child: ListView.builder(
          itemCount: preferences.length,
          itemBuilder: (context, index) {
            final prefKey = preferences.keys.elementAt(index);
            final prefValue = preferences.values.elementAt(index);
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
                    value: prefValue,
                    min: 0,
                    max: 10,
                    onChanged: (value) {
                      setState(() {
                        preferences[prefKey] = value.toInt();
                      });
                    },
                  ),
                  Text('${preferences[prefKey]}')
                ],
              )
            );
          })
        )
      ],
    );
  }
}