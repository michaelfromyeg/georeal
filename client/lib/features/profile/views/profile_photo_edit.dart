// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/common/profile_photo.dart';
import 'package:georeal/features/profile/view_model/profile_view_model.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/providers/user_provider';
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
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    model.fetchProfilePhoto(user.id);

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
      body: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: ProfilePhoto(
                  radius: MediaQuery.of(context).size.width / 4,
                  image: user.profilePhotoUrl != null
                      ? Image.network(user.profilePhotoUrl!)
                      : image,
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          _updateProfileDialogue(model, user.id));
                },
                child: const Text("Change Photo"),
              ),
            ],
          );
        },
      ),
    );
  }

  _updateProfileDialogue(ProfileViewModel model, int userId) {
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
                await model.updateProfilePhoto(ImageSource.camera, userId);
              },
              child: const Text("Take Photo")),
          ElevatedButton(
              onPressed: () async {
                await model.updateProfilePhoto(ImageSource.gallery, userId);
              },
              child: const Text("Choose from Library")),
        ],
      ),
    ));
  }
}
