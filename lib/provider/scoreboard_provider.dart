import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_flutter/model/user.dart';

class ScoreboardProvider with ChangeNotifier {
  List<User> users = [];

  List<User> get sortedUsers {
    users.sort(
      (b, a) => a.score.compareTo(
        b.score,
      ),
    );
    return users;
  }

  void addUser(String userName, int score, String mode, Uint8List? image) {
    users.add(
      User(
        score: score,
        username: userName,
        image: image,
        mode: mode,
      ),
    );

    saveData();
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();

    final usersData = json.encode(users);

    await prefs.setString("usersData", usersData);
  }

  Future<bool> loadData() async {
    final getPreferences = await SharedPreferences.getInstance();

    if (!getPreferences.containsKey("usersData")) {
      return false;
    }

    final extractedUsersData = json.decode(getPreferences.getString("usersData")!);

    users = [];

    for (final singleUser in extractedUsersData) {
      users.add(
        User(
          username: singleUser['username'],
          score: singleUser['score'],
          mode: singleUser['mode'],
          image: Uint8List.fromList((singleUser['image'] as String).codeUnits),
        ),
      );
    }

    return true;
  }
}
