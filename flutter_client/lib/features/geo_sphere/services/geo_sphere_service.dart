import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../global_variables.dart';
import '../../../models/geo_sphere_model.dart';
import '../../gallery/services/gallery_service.dart';

class GeoSphereService {
  final GalleryService _galleryService;
  final List<GeoSphere> _geoSpheres = [];

  GeoSphereService(this._galleryService);

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

    _galleryService.createGalleryForGeoSphere(newGeoSphere.galleryId);
  }

  void postGeoSphere({
    required GeoSphere geoSphere,
  }) async {
    try {
      print("geosphere: ${geoSphere.toGeoJsonString()}");
      http.Response res = await http.post(
        Uri.parse('${GlobalVariables.uri}/geofences'),
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
}
