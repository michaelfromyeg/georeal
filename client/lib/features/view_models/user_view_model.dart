import 'package:flutter/material.dart';

import '../../models/user.dart';

class UserViewModel extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
  );

  User get user => _user;

  void setUser(Map<String, dynamic> user) {
    _user = User.fromMap(user);
    notifyListeners();
  }
}
