class LEUser {
  String username;
  String userUid;
  List<dynamic> friends;
  List<dynamic> tables;
  Map<dynamic, dynamic> preferences;
  String userCity;
  String userState;
  String userZip;

  void updateUsername(String newUsername) {
    username = newUsername;
  }

  void updateUid(String newUid) {
    userUid = newUid;
  }

  void updateFriends(List<dynamic> newFriends) {
    friends = newFriends;
  }

  void updateTables(List<dynamic> newTables) {
    tables = newTables;
  }

  void updatePreferences(Map<String, dynamic> newPreferences) {
    preferences = newPreferences;
  }

  void updateCity(String newCity) {
    userCity = newCity;
  }

  void updateState(String newState) {
    userState = newState;
  }

  void updateZip(String newZip) {
    userZip = newZip;
  }

  LEUser(
    {
      required this.username,
      required this.userUid,
      required this.friends,
      required this.tables,
      required this.preferences,
      required this.userCity,
      required this.userState,
      required this.userZip
    }
  );
}