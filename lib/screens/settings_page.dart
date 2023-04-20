import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/leuser.dart';

import '../models/le_user.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late LEUser user = ref.watch(leUserProvider);

  String _city = '';
  String _state = '';
  String _zip = '';
  String _username = '';

  void updateLocation() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.userUid)
        .update({'city': _city, 'state': _state, 'zip': _zip});
  }

  void updateUsername() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.userUid)
        .update({'username': _username});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        const Text('Set Your Username',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
            controller: _usernameController,
            onChanged: (value) {
              setState(
                () {
                  _username = value;
                },
              );
            },
          ),
        ),
        ElevatedButton(
          child: const Text('Save Your Username'),
          onPressed: () {
            updateUsername();
          },
        ),
        const SizedBox(height: 75),
        const Text('Set Your Location',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'City',
            ),
            controller: _cityController,
            onChanged: (value) {
              setState(
                () {
                  _city = value;
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'State',
            ),
            controller: _stateController,
            onChanged: (value) {
              setState(
                () {
                  _state = value;
                },
              );
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Zip Code',
              ),
              controller: _zipController,
              onChanged: (value) {
                setState(
                  () {
                    _zip = value;
                  },
                );
              },
            )),
        ElevatedButton(
          child: const Text('Save Your Location'),
          onPressed: () {
            updateLocation();
          },
        )
      ],
    )));
  }
}
