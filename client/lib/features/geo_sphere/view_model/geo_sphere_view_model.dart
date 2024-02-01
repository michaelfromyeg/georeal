import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:location/location.dart';

import '../../location/location_view_model.dart';

/// Handles data and logic for the GeoSpheres

typedef LocationCallback = void Function(GeoSphere geoSphere);

class GeoSphereViewModel extends ChangeNotifier {
  final GeoSphereService _geoSphereService;
  final LocationViewModel _locationViewModel;

  GeoSphereViewModel(this._geoSphereService, this._locationViewModel);

  List<GeoSphere> get geoSpheres => _geoSphereService.geoSpheres;

  Future<void> setAndCreateGeoSphere(double radius, String name) async {
    LocationData? locationData = _locationViewModel.currentLocation;

    // Check if the location data is available and valid
    if (locationData != null &&
        locationData.latitude != null &&
        locationData.longitude != null) {
      _geoSphereService.createGeoSphere(
          locationData.latitude!, locationData.longitude!, radius, name);
      notifyListeners();
    } else {
      locationData = await _locationViewModel.fetchLocation();
      if (locationData != null &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        _geoSphereService.createGeoSphere(
            locationData.latitude!, locationData.longitude!, radius, name);
        notifyListeners();
      } else {
        // location data is still not available
        //  print("Location data is not available to create GeoSphere.");
      }
    }
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
    LocationData? currentLocation = _locationViewModel.currentLocation;

    // Check if location is null, if so manually update location
    if (currentLocation?.latitude == null ||
        currentLocation?.longitude == null) {
      currentLocation = await _locationViewModel.fetchLocation();
    }

    if (currentLocation?.latitude != null &&
        currentLocation?.longitude != null) {
      return _calculateDistance(currentLocation!.latitude!,
          currentLocation.longitude!, geoSphere.latitude, geoSphere.longitude);
    } else {
      // If location is still null, return a default value

      return double.infinity;
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Calculates the angular distance between two points on the surface of a sphere
  // Haversine (or great circle)
  double _calculateDistance(double startLatitude, double startLongitude,
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

  GeoSphere? isPointInGeoSphere(double pointLat, double pointLon) {
    for (GeoSphere geoSphere in geoSpheres) {
      double distanceFromCenter = _calculateDistance(
          geoSphere.latitude, geoSphere.longitude, pointLat, pointLon);
      if (distanceFromCenter <= geoSphere.radiusInMeters) {
        return geoSphere;
      }
    }
    return null;
  }

  Future<void> startLocationChecks(LocationCallback callback) async {
    // Request background location permission
    Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      LocationData? currentLocation = _locationViewModel.currentLocation;

      if (currentLocation == null) {
        print("Current location is null; are permissions set appropriately?");
      } else {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          // print(
          //   "Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");

          GeoSphere? isInGeoSphere = isPointInGeoSphere(
              currentLocation.latitude!, currentLocation.longitude!);

          if (isInGeoSphere != null) {
            //  print("The current location is inside the geosphere.");
            callback(isInGeoSphere);
          }
        } else {
          //   print("The current location is outside the geosphere.");
        }
      }
    });
  }
}
