// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/widgets/gallery_navbar.dart';
import 'package:georeal/models/geo_sphere_model.dart';

class GeoSphereGallery extends StatelessWidget {
  final GeoSphere geoSphere;
  const GeoSphereGallery({
    Key? key,
    required this.geoSphere,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GalleryNavBar(
              name: geoSphere.name,
            ),
          ],
        ),
      ),
    );
  }
}
