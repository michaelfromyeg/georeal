import 'package:flutter/material.dart';
import 'package:georeal/features/add_geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:georeal/features/home/services/location_service.dart';
import 'package:georeal/features/home/widgets/add_geo_sphere_widget.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

import '../widgets/map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    if (!isLocationServiceStarted) {
      locationService.startLocationChecks(geoSphereViewModel);
      isLocationServiceStarted = true;
    }
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
/*
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                
                Center(
                  child: Container(
                    height: 302,
                    width: MediaQuery.of(context).size.width - 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                ),
                /*
                Center(
                  child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 40,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: CustomMap(),
                    ),
                  ),
                ),
                */
                
              ],
            ),
            */
            Expanded(child: CustomMap()),
          ],
        ),
      ),
    );
  }
}
