import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final double radius;
  final Image image;
  const ProfilePhoto({super.key, required this.radius, required this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: image.image,
    );
  }
}
