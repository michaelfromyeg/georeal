import 'dart:convert';
import 'dart:developer';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

import '../../../models/geo_sphere_model.dart';

/// handles http requests for the GeoSpheres

class GeoSphereService {
  static void createGeoSphere({
    required GeoSphere geoSphere,
  }) async {
    try {
      log(geoSphere.geoSphereId);
      log(geoSphere.toGeoJsonString());

      http.Response res = await http.post(
        Uri.parse('${EnvVariables.uri}/geofences'),
        body: json
            .encode({'name': geoSphere.name, 'geojson': geoSphere.toGeoJson()}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (res.statusCode == 201) {
        // Handle the successful response here, e.g., updating UI or local data
        print('Geosphere created successfully');
      } else {
        // Handle the failure case
        print('Failed to create geosphere. Status code: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception("Error occured: $e");
    }
  }

  static Future<void> getAllGeoSpheres() async {
    try {
      var response = await http.get(Uri.parse('${EnvVariables.uri}/geofences'));

      if (response.statusCode == 200) {
        List<dynamic> geofencesData = json.decode(response.body);

        for (var geofenceData in geofencesData) {
          // TODO: handle geosjson data
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }
}
