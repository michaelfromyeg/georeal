// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/features/view_models/user_view_model.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/models/user.dart';
import 'package:provider/provider.dart';

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
              onPressed: () {
                final username =
                    Provider.of<UserViewModel>(context, listen: false)
                        .user
                        .username;
                Provider.of<FriendViewModel>(context, listen: false)
                    .sendFriendRequest(username, user.username);
              },
              child: const Text("Add Friend"),
            ),
          ],
        ),
      ),
    );
  }
}
