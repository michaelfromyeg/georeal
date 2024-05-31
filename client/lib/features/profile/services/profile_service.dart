import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<void> uploadProfilePhoto(int userId, File photo) async {
    var uri =
        Uri.parse('${EnvVariables.uri}/user/$userId/profile_photo/upload');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('photo', photo.path));
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        log('Photo uploaded successfully');
      } else if (response.statusCode == 404) {
        log('User not found');
      } else if (response.statusCode == 400) {
        log('No valid files were uploaded');
      } else {
        log('Failed to upload photo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<String> getProfilePhoto(int userId) async {
    try {
      var response = await http
          .get(Uri.parse('${EnvVariables.uri}/user/$userId/profile_photo'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var photoUrl = "${EnvVariables.uri}${data['photo_url']}";
        log("Fetched photo URL successfully: $photoUrl");
        return photoUrl;
      } else {
        throw Exception(
            'Failed to fetch photo. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      log('Error occurred while fetching photo: ${e.toString()}');
      rethrow;
    }
  }
}
