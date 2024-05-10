import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final double radius;
  const ProfilePhoto({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: const Icon(
        Icons.person,
        color: Colors.black,
      ),
    );
  }
}
