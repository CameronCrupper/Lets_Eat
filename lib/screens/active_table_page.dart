import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_eat/providers/leuser.dart';

import '../models/le_user.dart';
import '../models/restaurant.dart';

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

  late LEUser user = ref.watch(leUserProvider);
  int finalScore = 0;

  Restaurant winningRestaurant = Restaurant(
      id: '',
      streetAddress: '',
      cityStateZip: '',
      phoneNumber: '',
      name: '',
      imageUrl: '',
      categories: []);

  late bool loading = false;

  List<dynamic> _attendees = [];
  String _tableUid = '';
  String _tablename = '';
  Map<String, dynamic> _restaurant = {};

  Future<DocumentSnapshot<Map<String, dynamic>>> getTable(String table) async {
    final tableInfo =
        await FirebaseFirestore.instance.collection('tables').doc(table).get();
    return tableInfo;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFriend(
      String friend) async {
    final friendInfo =
        await FirebaseFirestore.instance.collection('users').doc(friend).get();
    return friendInfo;
  }

  void updateAttendees() {
    FirebaseFirestore.instance
        .collection('tables')
        .doc(_tableUid)
        .update({'attendees': _attendees});
  }

  void removeTableFromFriend(String friendUid) {
    FirebaseFirestore.instance.collection('users').doc(friendUid).update({
      'tables': FieldValue.arrayRemove([_tableUid])
    });
  }

  void findRestaurant() async {
    setState(() {
      loading = true;
    });
    final String url =
        'https://cors-anywhere.herokuapp.com/https://api.yelp.com/v3/businesses/search?location=${user.userCity}%2C%20${user.userState}%20${user.userZip}&term=restaurants&radius=20000&sort_by=distance&limit=50';
    try {
      var response = await Dio().get(url,
          options: Options(headers: {
            'Authorization':
                'Bearer rGBvlomkTgEsREMjSCEKHvdI7jEcBelFO-TW0gP_Dq0MXJoeNNOuLc2Is9naydJb034HSOX_YxGSX_EzhMFkBExJ0LRzroH37JGOf57sy2NMPUrQBuDqY7A2AZ0lZHYx',
            'accept': 'application/json',
            'Access-Control-Allow-Origin': '*'
          }));
      var restaurantList = [];
      for (var result in response.data['businesses']) {
        var csz =
            '${result['location']['city']}, ${result['location']['state']} ${result['location']['zip_code']}';
        var catList = [];
        for (var category in result['categories']) {
          catList.add(category['title']);
        }
        String imgUrl;
        if (result['image_url'] != null) {
          imgUrl = result['image_url'];
        } else {
          imgUrl =
              'https://www.svgrepo.com/show/92091/location-placeholder.svg';
        }
        var restaurant = Restaurant(
            id: result['id'],
            streetAddress: result['location']['address1'],
            cityStateZip: csz,
            phoneNumber: result['display_phone'],
            name: result['name'],
            imageUrl: imgUrl,
            categories: catList);
        restaurantList.add(restaurant);
      }
      List<Map<String, dynamic>> listToSort = [];
      for (var item in restaurantList) {
        int restaurantScore = 0;
        for (var attendee in _attendees) {
          var attendeeScore = 0;
          final thisAttendee = await FirebaseFirestore.instance
              .collection('users')
              .doc(attendee)
              .get();
          for (var category in item.categories) {
            if (thisAttendee.data()!['preferences'].containsKey('$category')) {
              int score = thisAttendee.data()!['preferences']['$category'];
              attendeeScore += score;
            }
          }
          restaurantScore += attendeeScore;
        }
        restaurantScore ~/ _attendees.length.toInt();
        listToSort.add({'id': '${item.id}', 'score': restaurantScore});
      }
      listToSort.sort((Map a, Map b) => a['score'] - b['score']);
      for (var item in restaurantList) {
        if (item.id == listToSort.last['id']) {
          winningRestaurant = item;
          finalScore = listToSort.last['score'];
        }
      }
      FirebaseFirestore.instance.collection('tables').doc(_tableUid).update({
        'restaurant': {
          'name': winningRestaurant.name,
          'streetAddress': winningRestaurant.streetAddress,
          'cityStateZip': winningRestaurant.cityStateZip,
          'phoneNumber': winningRestaurant.phoneNumber,
          'id': winningRestaurant.id,
          'imageUrl': winningRestaurant.imageUrl,
          'categories': winningRestaurant.categories,
          'score': finalScore
        }
      });
      setState(() {
        loading = false;
      });
    } catch (e) {
      log(e.toString());
    }
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
          if (snapshot.data!.data()!['score'] != null) {
            finalScore = snapshot.data!.data()!['score'];
          }
          if (_restaurant['name'] != 'none') {
            winningRestaurant.id = _restaurant['id'];
            winningRestaurant.name = _restaurant['name'];
            winningRestaurant.streetAddress = '';
            if (_restaurant['streetAddress'] != null) {
              winningRestaurant.streetAddress = _restaurant['streetAddress'];
            }
            winningRestaurant.cityStateZip = _restaurant['cityStateZip'];
            winningRestaurant.phoneNumber = _restaurant['phoneNumber'];
            winningRestaurant.imageUrl = _restaurant['imageUrl'];
            winningRestaurant.categories = _restaurant['categories'];
            finalScore = _restaurant['score'];
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen.shade600,
              leading: const BackButton(),
              title: Text(
                _tablename,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
                  if (_restaurant['name'] == 'none')
                    ElevatedButton(
                      onPressed: () {
                        findRestaurant();
                      },
                      child: const Text('Find a Restaurant'),
                    ),
                  if (loading == true)
                    const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  if (_restaurant['name'] != 'none')
                    Card(
                        child: Column(
                      children: [
                        Text(
                          winningRestaurant.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (winningRestaurant.streetAddress != '')
                          Text('${winningRestaurant.streetAddress}'),
                        Text('${winningRestaurant.cityStateZip}'),
                        Text(winningRestaurant.phoneNumber),
                        const Text('Categories:'),
                        for (var category in winningRestaurant.categories)
                          Text(category),
                        Text('The overall score: $finalScore'),
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: Image.network(winningRestaurant.imageUrl),
                        ),
                      ],
                    )),
                  const Text('Attendees:'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _attendees.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: getFriend(_attendees[index]),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Column(
                                children: <Widget>[
                                  const Divider(
                                    height: 1,
                                  ),
                                  const ListTile(
                                    leading: CircleAvatar(
                                      radius: 24.0,
                                      backgroundImage: AssetImage(
                                          'assets/images/avatar.png'),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${snapshot.data!.data()!['username']}'),
                                    ],
                                  ),
                                  const SizedBox(height: 1, width: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      _attendees.remove(
                                          snapshot.data!.data()!['uid']);
                                      updateAttendees();
                                      removeTableFromFriend(
                                          snapshot.data!.data()!['uid']);
                                      setState(() {});
                                    },
                                    child: const Text('Remove From Table'),
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
