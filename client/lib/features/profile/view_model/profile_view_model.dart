import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends ChangeNotifier {
  File? _profilePhoto;

  File? get profilePhoto => _profilePhoto;

  Future<void> updateProfilePhoto(ImageSource source) async {
    XFile? imageFile;
    if (source == ImageSource.camera) {
      imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (imageFile == null) return;
    File photo = File(imageFile.path);

    log("Updating profile photo", name: "ProfileViewModel");
    _profilePhoto = photo;
    notifyListeners();
  }
}
