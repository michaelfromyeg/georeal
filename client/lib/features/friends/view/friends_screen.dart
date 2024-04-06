import 'package:flutter/material.dart';
import 'package:georeal/features/friends/user_search_widget.dart';
import 'package:georeal/features/friends/view/friend_view_model.dart';
import 'package:provider/provider.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<FriendViewModel>(context, listen: false).fetchUsers();
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by username',
                      hintStyle: TextStyle(
                          color: Colors.white
                              .withOpacity(0.5)), // Adjust opacity as needed
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: false,

                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                  onPressed: () {
                    // Cancel button action
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.black, // Cancel button background color
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer<FriendViewModel>(
              builder: (context, model, child) {
                if (model.friends.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: model.friends.length,
                    itemBuilder: (context, index) {
                      final friend = model.friends[index];
                      return UserSearchWidget(username: friend.username);
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
