import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:location/location.dart';

class GeoSphereViewModel extends ChangeNotifier {
  final GeoSphereService _geoSphereService;

  GeoSphereViewModel(this._geoSphereService);

  List<GeoSphere> get geoSpheres => _geoSphereService.geoSpheres;

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
    _geoSphereService.createGeoSphere(latitude, longitude, radius, name);
    notifyListeners();
  }

  Future<String> getNeighborhood(double latitude, double longitude) async {
    try {
      List<geocode.Placemark> placemarks =
          await geocode.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        geocode.Placemark place = placemarks[0];
        return place.subLocality ??
            'Unknown'; // Returns the neighborhood or 'Unknown' if null
      }
      return 'No neighborhood found'; // Return this if placemarks list is empty
    } catch (e) {
      print("Error occurred: $e");
      return 'Error occurred'; // Return this in case of an error
    }
  }

  Future<double> getDistanceToGeoSphere(GeoSphere geoSphere) async {
    Location location = Location();
    LocationData currentLocation = await location.getLocation();

    return _geoSphereService.calculateDistance(currentLocation.latitude!,
        currentLocation.longitude!, geoSphere.latitude, geoSphere.longitude);
  }
}
