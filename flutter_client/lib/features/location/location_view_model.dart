import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

// Resposible for managing location state and handling periodic updates
class LocationViewModel extends ChangeNotifier {
  final Location _location = Location();
  LocationData? _currentLocation;
  Timer? _locationTimer;

  LocationData? get currentLocation => _currentLocation;

  LocationViewModel() {
    _initializeLocation();
  }

  void _initializeLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();

      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _updateLocation();
    _locationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateLocation();
    });

    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      // _checkGeoSphere();
    });
  }

  void _updateLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      _currentLocation = locationData;

      notifyListeners();
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  Future<LocationData?> fetchLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      _currentLocation = locationData;
      notifyListeners();
      return locationData;
    } catch (e) {
      print("Failed to get location: $e");
      return null;
    }
  }

/*
  void stopLocationChecks() {
    locationTimer?.cancel();
  }
*/
  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }
}
