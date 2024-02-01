import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../../gallery/widgets/custom_toast.dart';
import '../widgets/map.dart';

/// HomeScreen is the main screen of the app which contains the Map

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLocationServiceStarted = false;

  void showCustomToast(GeoSphere geoSphere) {
    // checking mounted here ensures that home screen is still
    // in widget tree before showing the toast
    if (mounted) {
      CustomToast.show(
        context,
        "You have entered ${geoSphere.name}, press this button to add to its gallery!",
        geoSphere,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    // TODO: move this to a seperate method in the geo sphere view model
    if (!isLocationServiceStarted) {
      geoSphereViewModel.startLocationChecks(showCustomToast);
      isLocationServiceStarted = true;
    } else {
      // TODO: Handle
    }
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomMap(),
          ),
        ],
      ),
    );
  }
}
