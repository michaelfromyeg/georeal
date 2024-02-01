import 'package:flutter/material.dart';

/// Navigation bar for the Gallery screen

class GalleryNavBar extends StatelessWidget {
  final String name;
  const GalleryNavBar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        Text(name,
            style:
                const TextStyle(fontSize: 20)), // Adjust text style as needed
        const SizedBox(
          width: 48, // Assuming this is the approximate width of the IconButton
        ),
      ],
    );
  }
}
