import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class ProfileLayout extends StatefulWidget {
  const ProfileLayout({super.key});

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  bool isRequested = false;

  @override
  Widget build(BuildContext context) {
    final FriendViewModel viewModel =
        Provider.of<FriendViewModel>(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ProfilePhoto(radius: 40),
            Column(
              children: [
                Text(
                  viewModel.selectedUser?.numPosts.toString() ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text("Memories"),
              ],
            ),
            Column(
              children: [
                Text(
                  viewModel.selectedUser?.numPlaces.toString() ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text("Spaces"),
              ],
            ),
            Column(
              children: [
                Text(
                  viewModel.selectedUser?.numFriends.toString() ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text("Friends"),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                children: [
                  Text(
                    "First Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRequested = !isRequested;
                    final viewModel =
                        Provider.of<FriendViewModel>(context, listen: false);
                    final senderUsername =
                        Provider.of<UserProvider>(context, listen: false)
                            .user!
                            .id;
                    viewModel.sendFriendRequest(
                        senderUsername, viewModel.selectedUser!.id);
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).hintColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isRequested
                        ? Center(
                            child: Text(
                              "Requested",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Add Friend",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
