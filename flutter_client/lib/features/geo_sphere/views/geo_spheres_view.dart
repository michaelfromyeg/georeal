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
            Expanded(
              child: ListView.builder(
                itemCount: geoSphereViewModel.geoSpheres.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                        child: Row(
                          children: [
                            const Icon(Icons.abc),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(geoSphereViewModel.geoSpheres[index].name),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
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
