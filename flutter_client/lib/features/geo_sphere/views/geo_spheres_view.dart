import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

import '../view_model/geo_sphere_view_model.dart';

class GeoSphereView extends StatelessWidget {
  const GeoSphereView({super.key});

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              "Geo spheres in your area",
              style: GlobalVariables.headerStyle,
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: geoSphereViewModel.geoSpheres.length,
                itemBuilder: (context, index) {
                  var geoSphere = geoSphereViewModel.geoSpheres[index];
                  return GestureDetector(
                    // This container helps with more accurate gesture detection
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //const SizedBox(width: 8),
                                Text(
                                  geoSphere.name,
                                  style: GlobalVariables.headerStyle,
                                ),
                                Row(
                                  children: [
                                    FutureBuilder<String>(
                                      future:
                                          geoSphereViewModel.getNeighborhood(
                                              geoSphere.latitude,
                                              geoSphere.longitude),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(); // Show loading indicator while waiting
                                        } else if (snapshot.hasError) {
                                          return const Text(
                                              'Error'); // Show error text on error
                                        } else {
                                          return Text(snapshot.data ??
                                              'Unknown'); // Show neighborhood or 'Unknown'
                                        }
                                      },
                                    ),
                                    const Text(","),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder<double>(
                                      future: geoSphereViewModel
                                          .getDistanceToGeoSphere(geoSphere),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(); // Show loading indicator while waiting
                                        } else if (snapshot.hasError) {
                                          return const Text(
                                              'Error'); // Show error text on error
                                        } else {
                                          return Text(
                                              '${snapshot.data.toString()} km' ??
                                                  'Unknown'); // Show neighborhood or 'Unknown'
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                //const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(geoSphere.name);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
