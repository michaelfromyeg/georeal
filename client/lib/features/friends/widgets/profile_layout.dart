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
  bool _isRequested = false;
  bool _isProcessing = false;

  Future<void> _handleAddFriend() async {
    setState(() => _isProcessing = true);
    try {
      final viewModel = Provider.of<FriendViewModel>(context, listen: false);
      final senderUsername =
          Provider.of<UserProvider>(context, listen: false).user?.id;
      if (senderUsername != null && viewModel.selectedUser?.id != null) {
        await viewModel.sendFriendRequest(
            senderUsername, viewModel.selectedUser!.id);
        setState(() => _isRequested = true);
      } else {
        // Handle error or invalid state
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

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
              const Text(
                "First Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                onTap: _isRequested || _isProcessing ? null : _handleAddFriend,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).hintColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isProcessing
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : Center(
                            child: Text(
                              _isRequested ? "Requested" : "Add Friend",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
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
