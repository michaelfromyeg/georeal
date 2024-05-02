// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/models/user.dart';

class UserProfileScreen extends StatelessWidget {
  User user;
  UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ],
            ),
            Text(
              user.username,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Add Friend"),
            ),
          ],
        ),
      ),
    );
  }
}
