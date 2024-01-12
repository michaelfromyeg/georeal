import '../../../models/gallery_model.dart';

class GalleryService {
  final Map<String, Gallery> _galleries = {};

  void createGalleryForGeoSphere(String geoSphereId) {
    _galleries[geoSphereId] = Gallery(id: geoSphereId);
  }

  void addPhotoToGallery(String geoSphereId, String photoPath) {
    final gallery = _galleries[geoSphereId];
    if (gallery != null) {
      gallery.photoPaths.add(photoPath);
    } else {
      print("Gallery with this id does not exist!");
    }
  }

  List<String> getPhotosFromGallery(String geoSphereId) {
    return _galleries[geoSphereId]?.photoPaths ?? [];
  }
}
