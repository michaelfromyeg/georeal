import 'dart:convert';
import 'dart:developer';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

import '../../../models/geo_sphere_model.dart';

/// handles http requests for the GeoSpheres

class GeoSphereService {
  static Future<GeoSphere> createGeoSphere({
    required int userID,
    required double radius,
    required double latitude,
    required double longitude,
    required String name,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${EnvVariables.uri}/geofences'),
        body: json.encode({
          'name': name,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
          'creator_id': userID
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (res.statusCode == 201) {
        GeoSphere geoSphere = GeoSphere(
            geoSphereId: json.decode(res.body)['id'],
            longitude: longitude,
            latitude: latitude,
            radius: radius,
            name: name,
            creatorId: userID);
        return geoSphere;
      } else {
        throw Exception(
            'Failed to create geosphere. Status code: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception("Error occured: $e");
    }
  }

  static Future<List<GeoSphere>?> getAllGeoSpheres() async {
    try {
      var response = await http.get(Uri.parse('${EnvVariables.uri}/geofences'));

      if (response.statusCode == 200) {
        List<dynamic> geofencesData = json.decode(response.body);
        log(response.body.toString(), name: 'responsebody');
        List<GeoSphere> geoSpheres = [];
        log(geofencesData.toString(), name: 'geofencesdata');
        for (var geofenceData in geofencesData) {
          geoSpheres.add(GeoSphere.fromJson(geofenceData));
        }
        log('GeoSpheres: ${geoSpheres.toString()}');
        return geoSpheres;
      } else {
        log('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  static Future<void> deleteGeoSphere(int id) async {
    log('Deleting geosphere with id: $id');
    try {
      var response = await http
          .delete(Uri.parse('${EnvVariables.uri}/geofences/delete/$id'));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete geosphere. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }
}
