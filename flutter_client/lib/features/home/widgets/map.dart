import 'dart:async';

import 'package:flutter/material.dart';
import 'package:georeal/features/add_geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

Location location = Location();

class _CustomMapState extends State<CustomMap> {
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    requestPermission();
    getLocation();
  }

  Future<void> requestPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> getLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GeoSphereViewModel>();
    Set<Circle> circles = viewModel.geoSpheres.map(
      (geoSphere) {
        return Circle(
          circleId: CircleId(
            geoSphere.name,
          ),
          center: LatLng(geoSphere.latitude, geoSphere.longitude),
          radius: geoSphere.radiusInMeters,
          strokeWidth: 2,
          fillColor: const Color.fromRGBO(90, 118, 226, 0.494),
        );
      },
    ).toSet();

    Set<Marker> markers = viewModel.geoSpheres.map(
      (geoSphere) {
        return Marker(
            markerId: MarkerId(geoSphere.name),
            position: LatLng(geoSphere.latitude, geoSphere.longitude),
            infoWindow: InfoWindow(title: geoSphere.name),
            onTap: () {});
      },
    ).toSet();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                zoom: 13.5,
              ),
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              circles: circles,
              markers: markers,
            ),
    );
  }
}
