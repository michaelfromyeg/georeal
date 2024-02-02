import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../gallery/views/geo_sphere_gallery.dart';
import '../../geo_sphere/view_model/geo_sphere_view_model.dart';
import '../../location/location_view_model.dart';

/// CustomMap is a widget that displays a Google Map

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/map/simple_style.json');
    _controller?.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel = context.watch<GeoSphereViewModel>();
    final locationViewModel = context.watch<LocationViewModel>();
    final LocationData? currentLocation = locationViewModel.currentLocation;

    Set<Circle> circles = geoSphereViewModel.geoSpheres.map(
      (geoSphere) {
        return Circle(
          consumeTapEvents: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GeoSphereGallery(geoSphere: geoSphere);
                },
              ),
            );
          },
          circleId: CircleId(geoSphere.name),
          center: LatLng(geoSphere.latitude, geoSphere.longitude),
          radius: geoSphere.radiusInMeters,
          strokeWidth: 2,
          fillColor: const Color.fromARGB(124, 90, 226, 142),
        );
      },
    ).toSet();

    Set<Marker> markers = geoSphereViewModel.geoSpheres.map(
      (geoSphere) {
        return Marker(
          markerId: MarkerId(geoSphere.name),
          position: LatLng(geoSphere.latitude, geoSphere.longitude),
          infoWindow: InfoWindow(title: geoSphere.name),
          draggable: true,
          onDragStart: (LatLng position) {
            // TODO: Move geo sphere when dragged to new location
            log("Dragging started at position: $position");
          },
          onDragEnd: (LatLng newPosition) {
            // TODO: Move geo sphere when dragged to new location
            log("Dragging ended at position: $newPosition");
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GeoSphereGallery(geoSphere: geoSphere);
                },
              ),
            );
          },
        );
      },
    ).toSet();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _loadMapStyle();
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                zoom: 13.5,
              ),
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              circles: circles,
              markers: markers,
            ),
    );
  }
}
