import 'dart:convert';

import 'package:uuid/uuid.dart';

class GeoSphere {
  double latitude;
  double longitude;
  double radiusInMeters;
  String name;
  final String galleryId;

  GeoSphere({
    required this.latitude,
    required this.longitude,
    required this.radiusInMeters,
    required this.name,
  }) : galleryId = const Uuid().v4();

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
      },
    };
  }

  String toGeoJsonString() {
    return jsonEncode(toGeoJson());
  }
}
