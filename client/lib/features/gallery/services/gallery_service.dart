import 'dart:io';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

/// Handles http requests for the Gallery

class GalleryService {
  Future<void> uploadPhoto(String geoSphereId, File photo) async {
    var uri = Uri.parse('${EnvVariables.uri}/geofences');

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
}
