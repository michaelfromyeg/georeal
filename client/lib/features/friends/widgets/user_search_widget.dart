import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

class UserSearchWidget extends StatelessWidget {
  final String username;
  final VoidCallback onTap;
  const UserSearchWidget(
      {super.key, required this.username, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            border:
                Border.all(color: GlobalVariables.backgroundColor, width: 1),
          ),
          child: Row(
            children: [
              const ProfilePhoto(
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(
                username,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        var viewModel = Provider.of<FriendViewModel>(context, listen: false);
        viewModel.getUserByUsername(username);
        onTap();
      },
    );
  }
}
