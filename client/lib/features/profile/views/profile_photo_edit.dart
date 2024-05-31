// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/profile/view_model/profile_view_model.dart';
import 'package:georeal/global_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePhotoEditScreen extends StatelessWidget {
  Image image;
  ProfilePhotoEditScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProfileViewModel>(context, listen: false);
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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (contet) => _updateProfileDialogue(model));
              },
              child: const Text("Change Photo"),
            ),
          ],
        ));
  }

  _updateProfileDialogue(ProfileViewModel model) {
    return AlertDialog(
        content: SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Change Profile Photo",
            style: GlobalVariables.bodyStyle.copyWith(color: Colors.black),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () async {
                await model.updateProfilePhoto(ImageSource.camera);
              },
              child: const Text("Take Photo")),
          ElevatedButton(
              onPressed: () async {
                await model.updateProfilePhoto(ImageSource.gallery);
              },
              child: const Text("Choose from Library")),
        ],
      ),
    ));
  }
}
