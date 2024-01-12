import 'dart:io';

import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/widgets/gallery_navbar.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:provider/provider.dart';

import '../services/gallery_service.dart';

// Import GalleryService

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
    // Dummy photo path (replace with an actual path of a local image)
    //const String dummyPhotoPath = 'assets/images/profile_photo.jpg';

    // Create a list of 9 dummy photo paths
    // List<String> photoPaths = List.filled(9, dummyPhotoPath);

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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 6,
                ),
                itemCount: photoPaths.length,
                itemBuilder: (context, index) {
                  String photoPath = photoPaths[index];
                  return GestureDetector(
                    child: Image.file(
                      File(photoPath),
                    ),
                    onTap: () => _showFullSizeImage(context, photoPath),
                  );
                  /*Image.asset(
                          photoPath); */ // Display the image (assuming these are network images)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showFullSizeImage(BuildContext context, String photoPath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.file(File(photoPath)),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
