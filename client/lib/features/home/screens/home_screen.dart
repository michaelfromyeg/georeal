import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/services/geo_sphere_service.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:georeal/features/location/location_service.dart';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../../gallery/widgets/custom_toast.dart';
import '../widgets/map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationService locationService = LocationService();
  bool isLocationServiceStarted = false;

  void showCustomToast(GeoSphere geoSphere) {
    if (mounted) {
      CustomToast.show(
        context,
        "You have entered ${geoSphere.name}, press this button to add to its gallery!",
        geoSphere,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //locationService.stopLocationChecks();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geoSphereService =
        Provider.of<GeoSphereService>(context, listen: false);
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    if (!isLocationServiceStarted) {
      // print("Working");
      geoSphereViewModel.startLocationChecks(showCustomToast);
      isLocationServiceStarted = true;
    } else {
      // handle
    }
    return const Scaffold(
      body: Column(
        children: [
          /*
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                "Geo-Real",
                style: GlobalVariables.headerStyle,
              ),
            ),
          ),
          AddGeoSphereWidget(),
          SizedBox(height: 20),
          */
          Expanded(child: CustomMap()),
        ],
      ),
    );
  }
}
