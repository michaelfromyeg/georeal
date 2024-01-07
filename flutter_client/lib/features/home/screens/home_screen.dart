import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:georeal/features/geo_sphere/geo_sphere_view_model.dart';
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/features/geo_sphere/services/location_service.dart';
import 'package:georeal/features/home/widgets/add_geo_sphere_widget.dart';
import 'package:georeal/global_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  LocationService locationService = LocationService();
  bool isLocationServiceStarted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    locationService.stopLocationChecks();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geoSphereService =
        Provider.of<GeoSphereService>(context, listen: false);
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    if (!isLocationServiceStarted) {
      locationService.startLocationChecks(geoSphereService);
      isLocationServiceStarted = true;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  "Geo-Real",
                  style: GlobalVariables.headerStyle,
                ),
              ),
            ),
            const AddGeoSphereWidget(),
            const SizedBox(height: 20),
            const Expanded(child: CustomMap()),
            ElevatedButton(
              onPressed: () => pickImage(),
              child: const Text("Pick Gallery"),
            ),
            ElevatedButton(
              onPressed: () {
                print("viewModel  ${geoSphereViewModel.geoSpheres}");
                print("service  ${geoSphereService.geoSpheres}");
              },
              child: const Text("Pick Camera"),
            ),
          ],
        ),
      ),
    );
  }
}
