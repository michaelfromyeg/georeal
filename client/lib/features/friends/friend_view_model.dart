import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/friends/friend_service.dart';
import 'package:georeal/models/user.dart';

class FriendViewModel extends ChangeNotifier {
  List<User> _users = [];
  User? _searchedUser;

  List<User> get friends => _users;
  User? get searchedUser => _searchedUser;

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

  void getUserByUsername(String username) async {
    try {
      _searchedUser = await UserService.getUserByUsername(username);
      log('Users fetched: $_users');
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
