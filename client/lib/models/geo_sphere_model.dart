// To parse this JSON data, do
//
//     final geofence = geofenceFromJson(jsonString);

import 'dart:convert';

GeoSphere geofenceFromJson(String str) => GeoSphere.fromJson(json.decode(str));

String geofenceToJson(GeoSphere data) => json.encode(data.toJson());

class GeoSphere {
  int geoSphereId;
  int creatorId;
  double latitude;
  double longitude;
  double radius;
  String name;

  GeoSphere({
    required this.geoSphereId,
    required this.creatorId,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
  });

  factory GeoSphere.fromJson(Map<String, dynamic> json) => GeoSphere(
        geoSphereId: json["id"],
        creatorId: json["creator_id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        radius: json["radius"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "geoSphereId": geoSphereId,
        "creatorId": creatorId,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
        "name": name,
      };

  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [longitude, latitude]
      },
      "properties": {
        "name": name,
        "radius": radius,
        "geoSphereId": geoSphereId,
      },
    };
  }

  String toGeoJsonString() {
    return jsonEncode(toGeoJson());
  }
}
