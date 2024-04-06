import 'package:flutter/material.dart';

class UserSearchWidget extends StatelessWidget {
  final String username;
  const UserSearchWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            username,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
