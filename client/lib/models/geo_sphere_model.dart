import 'dart:convert';

import 'package:uuid/uuid.dart';

/// Represents a GeoSphere object

class GeoSphere {
  double latitude;
  double longitude;
  double radiusInMeters;
  String name;
  final String geoSphereId;

  GeoSphere({
    required this.latitude,
    required this.longitude,
    required this.radiusInMeters,
    required this.name,
  }) : geoSphereId = const Uuid().v4();

  factory GeoSphere.fromMap(Map<String, dynamic> map) {
    var geojson = map['geojson'] as Map<String, dynamic>? ?? {};
    var geometry = geojson['geometry'] as Map<String, dynamic>? ?? {};
    var coordinates = geometry['coordinates'] as List<dynamic>? ?? [0.0, 0.0];
    var properties = geojson['properties'] as Map<String, dynamic>? ?? {};

    // Extracting name from the top level of the input map
    String name = map['name']?.toString() ??
        properties['name']?.toString() ??
        'Unknown Name';
    double latitude = coordinates.isNotEmpty ? coordinates[1].toDouble() : 0.0;
    double longitude = coordinates.isNotEmpty ? coordinates[0].toDouble() : 0.0;
    double radiusInMeters = properties['radius']?.toDouble() ?? 0.0;

    return GeoSphere(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
      name: name, // Use the correctly extracted name
    );
  }

  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [longitude, latitude]
      },
      "properties": {
        "name": name,
        "radius": radiusInMeters,
        "geoSphereId": geoSphereId,
      },
    };
  }

  String toGeoJsonString() {
    return jsonEncode(toGeoJson());
  }
}
