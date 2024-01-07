import 'package:flutter/material.dart';
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
        child: ListView.builder(
          itemCount: geoSphereViewModel.geoSpheres.length,
          itemBuilder: (context, index) {
            return Text(geoSphereViewModel.geoSpheres[index].name);
          },
        ),
      ),
    );
  }
}
