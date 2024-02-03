import 'package:flutter/material.dart';

import '../../../models/gallery_model.dart';

class GalleryViewModel extends ChangeNotifier {
  final Map<String, Gallery> _galleries = {};

  get galleries => _galleries;

  void createGallery(String geoSphereId) {
    _galleries[geoSphereId] = Gallery(id: geoSphereId);
  }

  void addPhotoToGallery(String geoSphereId, String photoPath) {
    final gallery = _galleries[geoSphereId];
    if (gallery != null) {
      gallery.photoPaths.add(photoPath);
    } else {
      Gallery newGallery = Gallery(id: geoSphereId);
      newGallery.photoPaths.add(photoPath);
      _galleries[geoSphereId] = newGallery;
    }
  }

  List<String> getPhotosFromGallery(String geoSphereId) {
    return _galleries[geoSphereId]?.photoPaths ?? [];
  }
}
