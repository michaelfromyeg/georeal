import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../../geo_sphere/view_model/geo_sphere_view_model.dart';

/// Navigation bar for the Gallery screen

class GalleryNavBar extends StatelessWidget {
  final GeoSphere geoSphere;
  const GalleryNavBar({super.key, required this.geoSphere});

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        Text(
          geoSphere.name,
          style: const TextStyle(
              fontSize: 20,
              color: GlobalVariables.secondaryColor,
              fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () async {
            final confirmDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content:
                      const Text('Are you sure you want to delete this item?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
            if (confirmDelete) {
              geoSphereViewModel.deleteGeoSphere(geoSphere);
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            }
          },
          iconSize: 24,
          icon: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
