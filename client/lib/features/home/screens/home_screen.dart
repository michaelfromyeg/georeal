import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/view_model/geo_sphere_view_model.dart';
import 'package:georeal/features/geo_sphere/widgets/geo_sphere_widget.dart';
import 'package:georeal/features/home/widgets/map_navbar.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

import '../widgets/map.dart';

/// HomeScreen is the main screen of the app which contains the Map
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMapPressed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isMapPressed
              ? const CustomMap()
              : SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: GlobalVariables.backgroundColor,
                    ),
                    padding: const EdgeInsets.only(top: 75),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<GeoSphereViewModel>(context,
                                      listen: false)
                                  .fetchGeoSpheres();
                            },
                            child: Text("Get GeoSphere")),
                        Expanded(
                          child: Consumer<GeoSphereViewModel>(
                            builder: (context, geoSphereViewModel, child) {
                              return ListView.builder(
                                itemCount: geoSphereViewModel.geoSpheres.length,
                                itemBuilder: (context, index) {
                                  var geoSphere =
                                      geoSphereViewModel.geoSpheres[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 8),
                                    child:
                                        GeoSphereWidget(geoSphere: geoSphere),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<GeoSphereViewModel>(
                builder: (context, geoSphereViewModel, child) {
                  return MapNavbar(
                    model: geoSphereViewModel,
                    onMapPressed: () {
                      setState(() {
                        isMapPressed = true;
                      });
                    },
                    onFeedPressed: () {
                      setState(() {
                        isMapPressed = false;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
