import 'dart:convert';

class GeoSphere {
  double latitude;
  double longitude;
  double radiusInMeters;
  String name;

  // constructor
  GeoSphere({
    required this.latitude,
    required this.longitude,
    required this.radiusInMeters,
    required this.name,
  });

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
