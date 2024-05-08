import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/friends/services/user_service.dart';
import 'package:georeal/models/other_user.dart';

class FriendViewModel extends ChangeNotifier {
  List<OtherUser> _searchedUsers = [];
  OtherUser? _selectedUser;

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
      log('User fetched: $_selectedUser');
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void sendFriendRequest(String senderUsername, String receiverUsername) async {
    try {
      await UserService.sendFriendRequest(senderUsername, receiverUsername);
      log('Friend request sent to $receiverUsername');
    } catch (e) {
      log(e.toString());
    }
  }
}
