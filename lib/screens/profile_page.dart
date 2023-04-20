import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/le_user.dart';

import '../providers/signed_in.dart';
import '../providers/leuser.dart';

import '../screens/home_page.dart';
import '../screens/friends_page.dart';
import '../screens/preferences_page.dart';
import '../screens/settings_page.dart';
import '../screens/tables_page.dart';
import '../screens/default_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late LEUser user = ref.watch(leUserProvider);

  int _selectedIndex = 0;

  void _selectedPage(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  static const List<Widget> _pages = <Widget>[
    DefaultPage(),
    FriendsPage(),
    TablesPage(),
    PreferencesPage(),
    SettingsPage(),
  ];

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final fbUser = FirebaseAuth.instance.currentUser;
    final currentUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(fbUser!.uid)
        .get();
    ref.read(leUserProvider.notifier).updateLEUser(LEUser(
        username: currentUser.data()!['username'],
        userUid: currentUser.data()!['uid'],
        friends: currentUser.data()!['friends'],
        tables: currentUser.data()!['tables'],
        preferences: currentUser.data()!['preferences'],
        userCity: currentUser.data()!['city'],
        userState: currentUser.data()!['state'],
        userZip: currentUser.data()!['zip']));
    user = ref.watch(leUserProvider);
    return currentUser;
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    ref.read(signedInProvider.notifier).state = false;
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen.shade600,
              title: Text('Welcome, ${user.username}!'),
              actions: [
                InkWell(
                  onTap: _signOut,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.logout),
                  ),
                )
              ],
            ),
            body: Center(
              child: _pages.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.grey[600],
              unselectedItemColor: Colors.grey[600],
              showUnselectedLabels: true,
              onTap: _selectedPage,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.house),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Friends',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.table_restaurant_rounded),
                  label: 'Tables',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Likes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
