import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../../gallery/views/geo_sphere_gallery.dart';
import '../view_model/geo_sphere_view_model.dart';

class GeoSphereWidget extends StatelessWidget {
  final GeoSphere geoSphere;
  const GeoSphereWidget({super.key, required this.geoSphere});

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel = Provider.of<GeoSphereViewModel>(context);
    return GestureDetector(
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 24, 31, 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                geoSphere.name,
                style: const TextStyle(
                    color: GlobalVariables.secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  FutureBuilder<String>(
                    future: geoSphereViewModel.getNeighborhood(
                        geoSphere.latitude, geoSphere.longitude),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return Text(
                          snapshot.data ?? 'Unknown',
                          style: const TextStyle(color: Colors.white),
                        );
                      }
                    },
                  ),
                  const Text(
                    ",",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  FutureBuilder<double>(
                    future:
                        geoSphereViewModel.getDistanceToGeoSphere(geoSphere),
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return Text(
                          '${snapshot.data!.toStringAsFixed(1)} km' ??
                              'Unknown',
                          style: const TextStyle(color: Colors.white),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Takes you to the gallery of the selected geo sphere
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeoSphereGallery(geoSphere: geoSphere),
          ),
        );
      },
    );
  }
}
