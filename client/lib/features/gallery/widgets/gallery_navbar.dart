import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/providers/user_provider';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../../geo_sphere/view_model/geo_sphere_view_model.dart';

/// AppBar for the Gallery screen
class GalleryNavBar extends StatelessWidget implements PreferredSizeWidget {
  final GeoSphere geoSphere;

  const GalleryNavBar({super.key, required this.geoSphere});

  @override
  Widget build(BuildContext context) {
    final geoSphereViewModel =
        Provider.of<GeoSphereViewModel>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Text(
        geoSphere.name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: GlobalVariables.secondaryColor,
        ),
      ),
      actions: <Widget>[
        if (geoSphere.creatorId == user?.id)
          IconButton(
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this GeoSphere?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );
              if (confirmDelete == true) {
                geoSphereViewModel.deleteGeoSphere(geoSphere);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            icon: const Icon(Icons.delete_rounded),
          ),
      ],
      backgroundColor: GlobalVariables.backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
