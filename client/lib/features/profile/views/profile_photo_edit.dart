// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';

class ProfilePhotoEditScreen extends StatelessWidget {
  Image image;
  ProfilePhotoEditScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ProfilePhoto(
                radius: MediaQuery.of(context).size.width / 4,
                image: Image.asset("assets/images/profile_photo.jpg"),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Change Photo"),
            ),
          ],
        ));
  }
}
