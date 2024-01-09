import 'dart:async';

import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:location/location.dart';

typedef LocationCallback = void Function(GeoSphere geoSphere);

class LocationService {
  final Location location = Location();
  Timer? locationTimer;

  // Params: geoSphereViewModel:
  Future<void> startLocationChecks(
      GeoSphereService geoSphereService, LocationCallback callback) async {
    // Request background location permission
    if (await location.requestPermission() == PermissionStatus.granted) {
      locationTimer =
          Timer.periodic(const Duration(seconds: 10), (timer) async {
        LocationData currentLocation = await location.getLocation();
        print(
            "Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");

        GeoSphere? isInGeoSphere = geoSphereService.isPointInGeoSphere(
            currentLocation.latitude!, currentLocation.longitude!);

        if (isInGeoSphere != null) {
          print("The current location is inside the geosphere.");
          callback(isInGeoSphere);
        } else {
          print("The current location is outside the geosphere.");
        }
        // TODO: Handle the location data as required
      });
    } else {
      print("Background location permission denied");
      // Optionally show a dialog or notification to the user
    }
  }

  void stopLocationChecks() {
    locationTimer?.cancel();
  }
}
