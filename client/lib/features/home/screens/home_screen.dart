import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/widgets/photo_prompt.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../widgets/map.dart';

/// HomeScreen is the main screen of the app which contains the Map

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLocationServiceStarted = false;
  List<GeoSphere> geoSpheres = [];

  void showCustomToast(List<GeoSphere> geoSpheres) {
    // checking mounted here ensures that home screen is still
    // in widget tree before showing the toast
    this.geoSpheres = geoSpheres;
    /*
    if (mounted) {
      CustomToast.show(
        context,
        "You have entered ${geoSpheres.last.name}, press this button to add to its gallery!",
        geoSpheres.last,
      );
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    // TODO: move this to a seperate method in the geo sphere view model
    if (!isLocationServiceStarted) {
      geoSphereViewModel.startLocationChecks(showCustomToast);
      log("Start location checks");
      isLocationServiceStarted = true;
    } else {
      // TODO: Handle
    }
    return Scaffold(
      body: Stack(
        children: [
          const Column(
            children: [
              Expanded(
                child: CustomMap(),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Consumer<GeoSphereViewModel>(
              builder: (context, geoSphereViewModel, child) {
                return SafeArea(
                  child: GestureDetector(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 28,
                          color: geoSphereViewModel.inGeoSphere
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    onTap: () => {
                      log("$geoSpheres"),
                      log("Tapped on camera button: ${geoSphereViewModel.inGeoSphere}"),
                      if (geoSphereViewModel.inGeoSphere)
                        {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return PhotoPrompt(
                                    geoSphereId: geoSpheres.last.geoSphereId);
                              })
                        }
                      else
                        {}
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
