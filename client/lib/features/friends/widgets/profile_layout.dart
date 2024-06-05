import 'package:flutter/material.dart';
import 'package:georeal/common/custom_progress_indicator.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/friends/view_model/friend_view_model.dart';
import 'package:georeal/features/friends/view_model/selected_user_view_model.dart';
import 'package:georeal/models/user.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class ProfileLayout extends StatefulWidget {
  final User user;
  const ProfileLayout({super.key, required this.user});

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  Future<void> _handleAddFriend() async {}

  @override
  Widget build(BuildContext context) {
    final FriendViewModel viewModel =
        Provider.of<FriendViewModel>(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfilePhoto(
              radius: 40,
              image: widget.user.profilePhotoUrl != null
                  ? Image.network(widget.user.profilePhotoUrl!)
                  : const Image(
                      image: AssetImage('assets/images/default_profile.png'),
                    ),
            ),
            Column(
              children: [
                Text(
                  viewModel.selectedUser?.numPosts.toString() ?? "0",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text("Memories"),
              ],
            ),
            Column(
              children: [
                Text(
                  viewModel.selectedUser?.numPlaces.toString() ?? "0",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text("Spaces"),
              ],
            ),
            Column(
              children: [
                Text(
                  viewModel.selectedUser?.numFriends.toString() ?? "0",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
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
              Text(
                viewModel.selectedUser?.name ?? "Unknown",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Consumer<SelectedUserViewModel>(
                builder: (context, model, child) {
                  return GestureDetector(
                    onTap: () {
                      model.sendFriendRequest(
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .id);
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).hintColor),
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: model.friendRequestStatus ==
                                FriendRequestStatus.loading
                            ? const Center(
                                child: CustomProgressIndicator(),
                              )
                            : Center(
                                child: Text(
                                  getFriendRequestLabel(
                                      model.friendRequestStatus),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  String getFriendRequestLabel(FriendRequestStatus status) {
    switch (status) {
      case FriendRequestStatus.pending:
        return "Pending";
      case FriendRequestStatus.friend:
        return "Friends";
      case FriendRequestStatus.notFriend:
        return "Add Friend";
      default:
        return "Add Friend";
    }
  }
}
