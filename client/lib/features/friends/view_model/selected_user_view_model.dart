import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/friends/services/user_service.dart';
import 'package:georeal/models/user.dart';

enum FriendRequestStatus {
  loading,
  pending,
  friend,
  notFriend,
}

class SelectedUserViewModel extends ChangeNotifier {
  final User _selectedUser;
  FriendRequestStatus _friendRequestStatus = FriendRequestStatus.notFriend;

  User get selectedUser => _selectedUser;
  FriendRequestStatus get friendRequestStatus => _friendRequestStatus;

  SelectedUserViewModel(this._selectedUser);

  Future<void> sendFriendRequest(int senderId) async {
    _friendRequestStatus = FriendRequestStatus.loading;
    notifyListeners();
    try {
      await UserService.sendFriendRequest(senderId, _selectedUser.id);
      _friendRequestStatus = FriendRequestStatus.pending;
      notifyListeners();
    } catch (e) {
      _friendRequestStatus = FriendRequestStatus.notFriend;
      notifyListeners();
      log(e.toString(), name: 'sendFriendRequest');
    }
  }
}
