import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../geo_sphere/view_model/geo_sphere_view_model.dart';
import '../../location/location_view_model.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel = context.watch<GeoSphereViewModel>();
    final locationViewModel = context.watch<LocationViewModel>();
    final LocationData? currentLocation = locationViewModel.currentLocation;

    Set<Circle> circles = geoSphereViewModel.geoSpheres.map(
      (geoSphere) {
        return Circle(
          circleId: CircleId(geoSphere.name),
          center: LatLng(geoSphere.latitude, geoSphere.longitude),
          radius: geoSphere.radiusInMeters,
          strokeWidth: 2,
          fillColor: const Color.fromRGBO(90, 118, 226, 0.494),
        );
      },
    ).toSet();

    Set<Marker> markers = geoSphereViewModel.geoSpheres.map(
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
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
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
