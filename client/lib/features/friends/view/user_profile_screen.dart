// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/features/friends/widgets/profile_layout.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/models/other_user.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  OtherUser user;
  UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Text(
          user.username,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileLayout(),
            ElevatedButton(
              onPressed: () {
                final username =
                    Provider.of<UserProvider>(context, listen: false)
                        .user
                        ?.username;
                Provider.of<FriendViewModel>(context, listen: false)
                    .sendFriendRequest(username!, user.username);
              },
              child: const Text("Add Friend"),
            ),
          ],
        ),
      ),
    );
  }
}
