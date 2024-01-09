import '../../models/gallery_model.dart';

class GalleryService {
  final Map<String, Gallery> _galleries = {};

  void createGalleryForGeoSphere(String geoSphereId) {
    _galleries[geoSphereId] = Gallery(id: geoSphereId);
  }

  void addPhotoToGallery(String geoSphereId, String photoPath) {
    final gallery = _galleries[geoSphereId];
    if (gallery != null) {
      print("photopath: $photoPath");
      gallery.photoPaths.add(photoPath);
      print("photopaths: ${gallery.photoPaths}");
    } else {
      print("Gallery with this id does not exist!");
    }
  }

  List<String> getPhotosFromGallery(String geoSphereId) {
    print(_galleries);
    print(geoSphereId);
    print(_galleries[geoSphereId]?.photoPaths);
    return _galleries[geoSphereId]?.photoPaths ?? [];
  }

  // Additional methods for gallery management
}
