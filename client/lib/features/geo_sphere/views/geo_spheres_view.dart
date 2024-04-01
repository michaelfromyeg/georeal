import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/widgets/geo_sphere_widget.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

import '../view_model/geo_sphere_view_model.dart';

/// View that displays all the geo spheres in the area

class GeoSphereView extends StatelessWidget {
  const GeoSphereView({super.key});

  @override
  Widget build(BuildContext context) {
    //final geoSphereViewModel =
    //    Provider.of<GeoSphereViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Places in your area",
          style: TextStyle(
              color: GlobalVariables.secondaryColor,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: GlobalVariables.backgroundColor,
      ),
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<GeoSphereViewModel>(
                  builder: (context, geoSphereViewModel, child) {
                return ListView.builder(
                  itemCount: geoSphereViewModel.geoSpheres.length,
                  itemBuilder: (context, index) {
                    var geoSphere = geoSphereViewModel.geoSpheres[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: GeoSphereWidget(geoSphere: geoSphere),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
