import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/friends/services/user_service.dart';
import 'package:georeal/models/user.dart';

class FriendViewModel extends ChangeNotifier {
  List<User> _searchedUsers = [];
  User? _selectedUser;
  final bool _friendRequestIsProcessing = false;
  final bool _hasRequested = false;
  TextEditingController searchController = TextEditingController();

  List<User> get searchedUsers => _searchedUsers;
  User? get selectedUser => _selectedUser;
  bool get friendRequestIsProcessing => _friendRequestIsProcessing;
  bool get hasRequested => _hasRequested;

  void fetchUsers() async {
    try {
      _searchedUsers = await UserService.getAllUsers();
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'fetchUsers');
    }
  }

  Future<void> getUserByUsername(String username, int userId) async {
    try {
      _selectedUser = await UserService.getUserByUsername(username, userId);
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'getUserByUsername');
    }
  }

  Future<void> searchUsers() async {
    try {
      _searchedUsers = await UserService.searchUsers(searchController.text);
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'searchUsers');
    }
  }
}
