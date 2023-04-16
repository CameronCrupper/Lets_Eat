import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:collection';

// import '../classes/le_user.dart';

// class userInfoNotifier extends StateNotifier<LEUser>{
//   userInfoNotifier():super(LEUser(
//     username: '',
//     tables: [],
//     friends: [],
//     preferences: {'':0},
//     uid: ''
//   ));

//   void updateUser(LEUser user) {
//     state = user;
//   }
// }

// final userInfoProvider = StateNotifierProvider<userInfoNotifier, LEUser>(
//   (ref) => userInfoNotifier()
// );

class UsernameNotifier extends StateNotifier<String> {
  UsernameNotifier():super('');

  void updateUsername(String username) {
    state = username;
  }
}

final usernameProvider = StateNotifierProvider<UsernameNotifier, String>(
  (ref) => UsernameNotifier()
);



class TablesNotifier extends StateNotifier<List<dynamic>> {
  TablesNotifier():super([]);

  void updateTables(List<dynamic> tables) {
    state = tables;
  }
}

final tablesProvider = StateNotifierProvider<TablesNotifier, List<dynamic>>(
  (ref) => TablesNotifier()
);



class FriendsNotifier extends StateNotifier<List<dynamic>> {
  FriendsNotifier():super([]);

  void updateFriends(List<dynamic> friends) {
    state = friends;
  }
}

final friendsProvider = StateNotifierProvider<FriendsNotifier, List<dynamic>>(
  (ref) => FriendsNotifier()
);



class PreferencesNotifier extends StateNotifier<Map<String, dynamic>> {
  PreferencesNotifier():super({'':0});

  void updatePreferences(Map<String, dynamic> preferences) {
    final sortedMap = SplayTreeMap<String, dynamic>.from(preferences,
      (a, b) => a.compareTo(b));
    state = sortedMap;
  }
}

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, Map<String, dynamic>>(
  (ref) => PreferencesNotifier()
);



class UidNotifier extends StateNotifier<String> {
  UidNotifier():super('');

  void updateUid(String uid) {
    state = uid;
  }
}

final uidProvider = StateNotifierProvider<UidNotifier, String>(
  (ref) => UidNotifier()
);