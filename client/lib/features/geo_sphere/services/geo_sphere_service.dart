import 'dart:convert';
import 'dart:developer';

import 'package:georeal/constants/env_variables.dart';
import 'package:http/http.dart' as http;

import '../../../models/geo_sphere_model.dart';
import '../../gallery/services/gallery_service.dart';

/// handles http requests for the GeoSpheres

class GeoSphereService {
  final GalleryService _galleryService;
  final List<GeoSphere> _geoSpheres = [];

  GeoSphereService(this._galleryService) {
    getAllGeoSpheres();
  }

  List<GeoSphere> get geoSpheres => _geoSpheres;

  void createGeoSphere(
      double latitude, double longitude, double radius, String name) {
    var newGeoSphere = GeoSphere(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radius,
      name: name,
    );

    _geoSpheres.add(newGeoSphere);
    postGeoSphere(geoSphere: newGeoSphere);

    _galleryService.createGalleryForGeoSphere(newGeoSphere.geoSphereId);
  }

  void postGeoSphere({
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

  Future<void> getAllGeoSpheres() async {
    try {


      var response = await http.get(Uri.parse('${EnvVariables.uri}/geofences'));


      if (response.statusCode == 200) {
        List<dynamic> geofencesData = json.decode(response.body);
        // Process the data
        // Assuming GeoSphere.fromMap() is a constructor that creates a GeoSphere from a Map
        _geoSpheres.clear();
        for (var geofenceData in geofencesData) {
          _geoSpheres.add(GeoSphere.fromMap(geofenceData));
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }
}
