import 'dart:io';

import 'package:flutter/material.dart';
import 'package:georeal/features/geo_sphere/widgets/gallery_navbar.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:provider/provider.dart';

import '../../gallery/gallery_service.dart'; // Import GalleryService

class GeoSphereGallery extends StatelessWidget {
  final GeoSphere geoSphere;
  // Add GalleryService

  const GeoSphereGallery({
    Key? key,
    required this.geoSphere,
    // Add GalleryService to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final galleryService = Provider.of<GalleryService>(context, listen: false);
    List<String> photoPaths = galleryService
        .getPhotosFromGallery(geoSphere.galleryId); // Fetch photo paths

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GalleryNavBar(
              name: geoSphere.name,
            ),
            Expanded(
              // Wrap ListView.builder with Expanded
              child: ListView.builder(
                itemCount: photoPaths.length,
                itemBuilder: (context, index) {
                  String photoPath = photoPaths[index];
                  return Image.file(
                    File(photoPath),
                  ); // Display the image (assuming these are network images)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
