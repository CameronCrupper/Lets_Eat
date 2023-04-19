import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:collection';

import '../models/le_user.dart';

class LEUserNotifier extends StateNotifier<LEUser> {
  LEUserNotifier():
  super(
    LEUser(
      username: '',
      userUid: '',
      friends: [],
      tables: [],
      preferences: {'':0},
      userCity: '',
      userState: '',
      userZip: ''
    )
  );

  void updateLEUser(LEUser newLEUser) {
    state.username = newLEUser.username;
    state.userUid = newLEUser.userUid;
    state.friends = newLEUser.friends;
    state.tables = newLEUser.tables;
    final sortedMap = SplayTreeMap<String, dynamic>.from(newLEUser.preferences,
      (a, b) => a.compareTo(b));
    state.preferences = sortedMap;
    state.userCity = newLEUser.userCity;
    state.userState = newLEUser.userState;
    state.userZip = newLEUser.userZip;
  }
}

final leUserProvider = StateNotifierProvider<LEUserNotifier, LEUser>(
  (ref) => LEUserNotifier()
);