import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/friends/view/friend_service.dart';
import 'package:georeal/models/user.dart';

class FriendViewModel extends ChangeNotifier {
  List<User> _users = [];

  List<User> get friends => _users;

  FriendViewModel() {
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      _users = await UserService.getAllUsers();
      log('Users fetched: $_users');
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
