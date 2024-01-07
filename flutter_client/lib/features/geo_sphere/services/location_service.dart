import 'dart:async';

import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();
  Timer? locationTimer;

  // Params: geoSphereViewModel:
  Future<void> startLocationChecks(GeoSphereService geoSphereService) async {
    // Request background location permission
    if (await location.requestPermission() == PermissionStatus.granted) {
      locationTimer =
          Timer.periodic(const Duration(seconds: 10), (timer) async {
        LocationData currentLocation = await location.getLocation();
        print(
            "Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");

        bool isInGeoSphere = geoSphereService.isPointInGeoSphere(
            currentLocation.latitude!, currentLocation.longitude!);

        if (isInGeoSphere) {
          print("The current location is inside the geosphere.");
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
