import 'package:flutter/material.dart';

import '../../../models/gallery_model.dart';

class GalleryViewModel extends ChangeNotifier {
  final Map<int, Gallery> _galleries = {};

  get galleries => _galleries;

  void createGallery(int geoSphereId) {
    _galleries[geoSphereId] = Gallery(id: geoSphereId);
    notifyListeners();
  }

  void addPhotoToGallery(int geoSphereId, String photoPath) {
    final gallery = _galleries[geoSphereId];
    if (gallery != null) {
      gallery.photoPaths.add(photoPath);
      notifyListeners();
    } else {
      Gallery newGallery = Gallery(id: geoSphereId);
      newGallery.photoPaths.add(photoPath);
      _galleries[geoSphereId] = newGallery;
      notifyListeners();
    }
  }

  List<String> getPhotosFromGallery(int geoSphereId) {
    return _galleries[geoSphereId]?.photoPaths ?? [];
  }
}
