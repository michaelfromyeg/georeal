import 'dart:io';

import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/services/gallery_service.dart';

import '../../../models/gallery_model.dart';

class GalleryViewModel extends ChangeNotifier {
  final Map<int, Gallery> _galleries = {};

  get galleries => _galleries;

  void createGallery(int geoSphereId) {
    _galleries[geoSphereId] = Gallery(id: geoSphereId);
    notifyListeners();
  }

  // void addPhotoToGallery(int geoSphereId, String photoPath) {
  //   final gallery = _galleries[geoSphereId];
  //   if (gallery != null) {
  //     gallery.photoPaths.add(photoPath);
  //     notifyListeners();
  //   } else {
  //     Gallery newGallery = Gallery(id: geoSphereId);
  //     newGallery.photoPaths.add(photoPath);
  //     _galleries[geoSphereId] = newGallery;
  //     notifyListeners();
  //   }
  // }

  Future<void> addPhotoToGallery(
      int geoSphereID, File photo, int userID) async {
    await GalleryService.uploadPhoto(geoSphereID, userID, photo);
  }

  Future<void> fetchGallery(int geoSphereId) async {
    List<String>? photoUrls =
        await GalleryService.getPhotosByGeoSphereId(geoSphereId);

    if (photoUrls == null || photoUrls.isEmpty) {
      // Optionally handle the case where no photos are found
    }

    final gallery = _galleries[geoSphereId];

    if (gallery != null) {
      // Update existing gallery
      gallery.photoPaths = photoUrls;
      notifyListeners();
    } else {
      // Create a new gallery if one doesn't exist
      _galleries[geoSphereId] = Gallery(id: geoSphereId, photoPaths: photoUrls);
      notifyListeners();
    }
  }

  List<String> getPhotosFromGallery(int geoSphereId) {
    return _galleries[geoSphereId]?.photoPaths ?? [];
  }
}
