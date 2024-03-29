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
    var geojson = map['geojson'] ?? {};
    var geometry = geojson['geometry'] ?? {};
    var properties = geojson['properties'] ?? {};

    return GeoSphere(
      latitude:
          geometry['coordinates'] != null ? geometry['coordinates'][1] : 0.0,
      longitude:
          geometry['coordinates'] != null ? geometry['coordinates'][0] : 0.0,
      radiusInMeters: properties['radius'] ?? 0.0,
      name: properties['name'] ?? '',
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
