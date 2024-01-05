import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';
import '../../../models/geo_sphere_model.dart';

class GeoSphereServices {
  void createGeoSphere({
    required GeoSphere geoSphere,
  }) async {
    try {
      print("geosphere ${geoSphere.toGeoJsonString()}");
      http.Response res = await http.post(
        Uri.parse('${GlobalVariables.uri}/geofences'),
        body: json
            .encode({'name': geoSphere.name, 'geojson': geoSphere.toGeoJson()}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      log("Geo Sphere Successfully logged! ");
    } catch (e) {
      throw Exception("Error occured: $e");
    }
  }
}
