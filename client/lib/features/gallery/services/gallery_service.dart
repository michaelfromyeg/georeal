import 'dart:io';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

import '../../../models/gallery_model.dart';

/// Handles http requests for the Gallery

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

  Future<void> uploadPhoto(String geoSphereId, File photo) async {

    var uri = Uri.parse('${EnvVariables.uri}/geofences'),

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('photo', photo.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Photo uploaded successfully');
      } else {
        print('Failed to upload photo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  List<String> getPhotosFromGallery(String geoSphereId) {
    return _galleries[geoSphereId]?.photoPaths ?? [];
  }
}
