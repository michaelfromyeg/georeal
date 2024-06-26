import 'dart:async';
import 'dart:developer' as log;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:location/location.dart';

import '../../location/location_view_model.dart';

/// Handles data and logic for the GeoSpheres

typedef LocationCallback = void Function(List<GeoSphere> geoSphere);

class GeoSphereViewModel extends ChangeNotifier {
  bool inGeoSphere = false;

  final LocationViewModel _locationViewModel;
  final List<GeoSphere> _geoSpheres = [];
  List<GeoSphere> _selectedUserGeoSpheres = [];

  GeoSphereViewModel(this._locationViewModel) {
    fetchGeoSpheres();
  }

  List<GeoSphere> get geoSpheres => _geoSpheres;
  List<GeoSphere> get selectedUserGeoSpheres => _selectedUserGeoSpheres;

  Future<void> fetchGeoSpheres() async {
    List<GeoSphere>? geoSpheres = await GeoSphereService.getAllGeoSpheres();
    if (geoSpheres != null) {
      _geoSpheres.addAll(geoSpheres);
      notifyListeners();
    }
  }

  Future<void> fetchUserGeoSpheres(int userID) async {
    List<GeoSphere>? userGeoSpheres =
        await GeoSphereService.getGeoSpheresByUserId(userID);
    if (userGeoSpheres != null) {
      _selectedUserGeoSpheres = userGeoSpheres;
      notifyListeners();
    }
  }

  Future<void> setAndCreateGeoSphere(
      double radius, String name, int userID) async {
    LocationData? locationData = _locationViewModel.currentLocation;

    // Check if the location data is available and valid
    if (locationData != null &&
        locationData.latitude != null &&
        locationData.longitude != null) {
      GeoSphere? newGeoSphere = await GeoSphereService.createGeoSphere(
          userID: userID,
          radius: radius,
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          name: name);
      if (newGeoSphere is GeoSphere) {
        _geoSpheres.add(newGeoSphere);
        notifyListeners();
      }
    } else {
      locationData = await _locationViewModel.fetchLocation();
      if (locationData != null &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        GeoSphere? newGeoSphere = await GeoSphereService.createGeoSphere(
            radius: radius,
            userID: userID,
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
            name: name);
        if (newGeoSphere != null) {
          _geoSpheres.add(newGeoSphere);
          notifyListeners();
        }
      } else {
        // location data is still not available
      }
    }
  }

  Future<void> deleteGeoSphere(GeoSphere geoSphereToDelete) async {
    await GeoSphereService.deleteGeoSphere(geoSphereToDelete.geoSphereId);
    _geoSpheres
        .removeWhere((geoSphere) => geoSphere.name == geoSphereToDelete.name);
    notifyListeners();
  }

  Future<String> getNeighborhood(double latitude, double longitude) async {
    try {
      List<geocode.Placemark> placemarks =
          await geocode.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        geocode.Placemark place = placemarks[0];
        return place.subLocality ?? 'Unknown';
      }
      return 'No neighborhood found';
    } catch (e) {
      log.log("Error occurred: $e");
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

  // Returns the GeoSphere that contains the coordinate
  List<GeoSphere> isPointInGeoSphere(double pointLat, double pointLon) {
    List<GeoSphere> containingGeoSpheres = [];

    for (GeoSphere geoSphere in geoSpheres) {
      double distanceFromCenter = _calculateDistance(
          geoSphere.latitude, geoSphere.longitude, pointLat, pointLon);
      if (distanceFromCenter <= geoSphere.radius) {
        containingGeoSpheres.add(geoSphere);
      }
    }
    return containingGeoSpheres;
  }

  Future<void> startLocationChecks() async {
    // Request background location permission
    Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) async {
        LocationData? currentLocation = _locationViewModel.currentLocation;

        if (currentLocation == null) {
          log.log(
              "Current location is null; are permissions set appropriately?");
        } else {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            List<GeoSphere> currentGeoSpheres = isPointInGeoSphere(
                currentLocation.latitude!, currentLocation.longitude!);

            if (currentGeoSpheres.isNotEmpty) {
              inGeoSphere = true;
              notifyListeners();
            }
          } else {
            inGeoSphere = false;
            notifyListeners();
          }
        }
      },
    );
  }
}
