import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

/// Handles http requests for the Gallery

class GalleryService {
  static Future<void> uploadPhoto(
      int geoSphereId, int userId, File photo) async {
    var uri =
        Uri.parse('${EnvVariables.uri}/geofences/$geoSphereId/upload_photo');

    var request = http.MultipartRequest('POST', uri)
      ..fields['author_id'] = userId.toString()
      ..files.add(await http.MultipartFile.fromPath('photo', photo.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        log('Photo uploaded successfully');
      } else if (response.statusCode == 404) {
        log('Geofence not found');
      } else if (response.statusCode == 400) {
        log('No valid files were uploaded');
      } else {
        log('Failed to upload photo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<List<String>> getPhotosByGeoSphereId(int geoSphereId) async {
    try {
      var response = await http
          .get(Uri.parse('${EnvVariables.uri}/geofences/$geoSphereId/posts'));

      if (response.statusCode == 200) {
        List<dynamic> photosData = json.decode(response.body);
        List<String> photoUrls = photosData
            .map((photoData) => "${EnvVariables.uri}${photoData['photo_url']}")
            .toList();
        log("Fetched photo URLs successfully: $photoUrls");
        return photoUrls;
      } else {
        throw Exception(
            'Failed to fetch photos. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      log('Error occurred while fetching photos: ${e.toString()}');
      rethrow; // This allows further handling of the error, such as showing a user-friendly message or error state UI.
    }
  }
}
