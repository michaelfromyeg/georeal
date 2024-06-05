import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:georeal/features/friends/services/user_service.dart';
import 'package:georeal/models/friend_request.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

class FriendRequestScreen extends StatelessWidget {
  const FriendRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(); // or redirect to login screen
      });
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Friend Requests"),
      ),
      body: FutureBuilder<List<FriendRequest>>(
        future: UserService.getAllFriendRequests(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FriendRequestItem(request: snapshot.data![index]);
              },
            );
          } else {
            return const Center(child: Text("No friend requests"));
          }
        },
      ),
    );
  }
}

class FriendRequestItem extends StatefulWidget {
  final FriendRequest request;
  const FriendRequestItem({super.key, required this.request});

  @override
  State<FriendRequestItem> createState() => _FriendRequestItemState();
}

class _FriendRequestItemState extends State<FriendRequestItem> {
  bool _isProcessing = false;
  String? _actionResult;

  void _handleFriendRequest(bool accept) async {
    setState(() => _isProcessing = true);
    try {
      if (accept) {
        await UserService.acceptFriendRequest(widget.request.id);
        _actionResult = "Accepted";
      } else {
        await UserService.rejectFriendRequest(widget.request.id);
        _actionResult = "Rejected";
      }
    } catch (e) {
      _actionResult = "Error";
    }
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            widget.request.senderUsername,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      trailing: _isProcessing
          ? const CupertinoActivityIndicator()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_actionResult == null)
                  GestureDetector(
                    onTap: () => _handleFriendRequest(true),
                    child: Container(
                      width: 70,
                      height: 25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(4)),
                      child: const Center(
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                if (_actionResult == null)
                  GestureDetector(
                    onTap: () => _handleFriendRequest(false),
                    child: Container(
                      width: 70,
                      height: 25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(4)),
                      child: const Center(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_actionResult != null)
                  Text(
                    _actionResult!,
                    style: TextStyle(
                      color: _actionResult == "Accepted"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
    );
  }
}
