import 'dart:io';

import 'package:flutter/material.dart';
import 'package:georeal/features/profile/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends ChangeNotifier {
  File? _profilePhoto;
  String? _profilePhotoUrl;

  File? get profilePhoto => _profilePhoto;
  String? get profilePhotoUrl => _profilePhotoUrl;

  Future<void> updateProfilePhoto(ImageSource source, int userId) async {
    XFile? imageFile;
    if (source == ImageSource.camera) {
      imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (imageFile == null) return;
    File photo = File(imageFile.path);

    ProfileService.uploadProfilePhoto(userId, photo);
    _profilePhoto = photo;
    notifyListeners();
    await fetchProfilePhoto(userId);
  }

  Future<void> fetchProfilePhoto(int userId) async {
    String photoUrl = await ProfileService.getProfilePhoto(userId);
    _profilePhotoUrl = photoUrl;
    notifyListeners();
  }
}
