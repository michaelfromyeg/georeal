import 'package:flutter/material.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:location/location.dart';

import 'geo_sphere_service.dart';

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
}
