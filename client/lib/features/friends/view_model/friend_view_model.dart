import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/friends/services/user_service.dart';
import 'package:georeal/models/other_user.dart';

class FriendViewModel extends ChangeNotifier {
  List<OtherUser> _searchedUsers = [];
  OtherUser? _selectedUser;
  TextEditingController searchController = TextEditingController();

  List<OtherUser> get searchedUsers => _searchedUsers;
  OtherUser? get selectedUser => _selectedUser;

  void fetchUsers() async {
    try {
      _searchedUsers = await UserService.getAllUsers();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUserByUsername(String username, int userId) async {
    try {
      _selectedUser = await UserService.getUserByUsername(username, userId);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendFriendRequest(int senderId, int receiverId) async {
    try {
      await UserService.sendFriendRequest(senderId, receiverId);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> searchUsers() async {
    try {
      _searchedUsers = await UserService.searchUsers(searchController.text);
      log(_searchedUsers.toString(), name: 'Searched users');
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
