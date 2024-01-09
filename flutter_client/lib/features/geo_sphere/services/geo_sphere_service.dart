import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../../constants/global_variables.dart';
import '../../../models/geo_sphere_model.dart';

class GeoSphereService {
  final List<GeoSphere> _geoSpheres = [];

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
  }

  // Calculates the angular distance between two points on the surface of a sphere
  // Haversine (or great circle)
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    const earthRadiusInKM = 6371; // Earth radius in kilometers

    // Differences in coordinates converted to radians
    var deltaLatitudeRadians = _degreesToRadians(endLatitude - startLatitude);
    var deltaLongitudeRadians =
        _degreesToRadians(endLongitude - startLongitude);

    // Convert starting and ending latitudes from degrees to radians
    startLatitude = _degreesToRadians(startLatitude);
    endLatitude = _degreesToRadians(endLatitude);

    // Haversine formula calculation
    var haversineOfCentralAngle =
        sin(deltaLatitudeRadians / 2) * sin(deltaLatitudeRadians / 2) +
            sin(deltaLongitudeRadians / 2) *
                sin(deltaLongitudeRadians / 2) *
                cos(startLatitude) *
                cos(endLatitude);
    var centralAngle = 2 *
        atan2(sqrt(haversineOfCentralAngle), sqrt(1 - haversineOfCentralAngle));

    // Return distance using the Earth's radius
    return earthRadiusInKM * centralAngle;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  bool isPointInGeoSphere(double pointLat, double pointLon) {
    for (GeoSphere geoSphere in geoSpheres) {
      double distanceFromCenter = calculateDistance(
          geoSphere.latitude, geoSphere.longitude, pointLat, pointLon);
      if (distanceFromCenter <= geoSphere.radiusInMeters) {
        return true;
      }
    }
    return false;
  }

  void postGeoSphere({
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
    } catch (e) {
      throw Exception("Error occured: $e");
    }
  }
}
