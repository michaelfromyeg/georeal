import 'dart:async';
import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

/// Resposible for managing location state and handling periodic updates

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

    initBackgroundFetch();

    _updateLocation();
    _locationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateLocation();
    });

    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      // _checkGeoSphere();
    });
  }

  void initBackgroundFetch() {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval:
              15, // <-- Set the minimum fetch interval in minutes
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      // This is the fetch event callback, where you update your location
      _updateLocation();
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      log('Background Fetch initialized with status: $status');
    }).catchError((e) {
      log('Background Fetch failed to initialize: $e');
    });
  }

  void _updateLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      _currentLocation = locationData;

      notifyListeners();
    } catch (e) {
      log("Failed to get location: $e");
    }
  }

  Future<LocationData?> fetchLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      _currentLocation = locationData;
      notifyListeners();
      return locationData;
    } catch (e) {
      log("Failed to get location: $e");
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
