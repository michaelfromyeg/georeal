import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/friends/view/user_profile_screen.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class UserSearchWidget extends StatelessWidget {
  final String username;

  const UserSearchWidget({super.key, required this.username});

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
              ProfilePhoto(
                radius: 20,
                image: Image.asset("assets/images/profile_photo.jpg"),
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
      onTap: () async {
        var viewModel = Provider.of<FriendViewModel>(context, listen: false);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User data is not available.'),
            duration: Duration(seconds: 2),
          ));
        }

        await viewModel.getUserByUsername(username, userProvider.user!.id);
        if (context.mounted) {
          if (viewModel.selectedUser == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Selected user data is not available.'),
              duration: Duration(seconds: 2),
            ));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfileScreen(user: viewModel.selectedUser!),
              ),
            );
          }
        }
      },
    );
  }
}
