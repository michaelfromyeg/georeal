import 'dart:math';

import 'package:flutter/material.dart';
import 'package:georeal/features/add_geo_sphere/services/geo_sphere_services.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:location/location.dart';

class GeoSphereViewModel extends ChangeNotifier {
  List<GeoSphere> geoSpheres = [];

  void createGeoSphere(
      double latitude, double longitude, double radius, String name) {
    GeoSphere newGeoSphere = GeoSphere(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radius,
      name: name,
    );
    GeoSphereServices geoSphereServices = GeoSphereServices();
    geoSphereServices.createGeoSphere(geoSphere: newGeoSphere);
    geoSpheres.add(newGeoSphere);

    notifyListeners();
  }

  Future<void> setAndCreateGeoSphere(double radius, String name) async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    double latitude = locationData.latitude!;
    double longitude = locationData.longitude!;
    createGeoSphere(latitude, longitude, radius, name);
    notifyListeners();
  }

  // Calculates the angular distance between two points on the surface of a sphere
  // Haversine (or great circle)
  double _haversineDistance(double startLatitude, double startLongitude,
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
      double distanceFromCenter = _haversineDistance(
          geoSphere.latitude, geoSphere.longitude, pointLat, pointLon);
      if (distanceFromCenter <= geoSphere.radiusInMeters) {
        return true;
      }
    }
    return false;
  }
}
