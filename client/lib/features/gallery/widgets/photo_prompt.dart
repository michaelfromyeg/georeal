import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:georeal/features/gallery/view_model/gallery_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../models/geo_sphere_model.dart';
import '../views/geo_sphere_gallery.dart';

/// Prompt to add a photo to a GeoSphere

class PhotoPrompt extends StatefulWidget {
  final GeoSphere geosphere;
  const PhotoPrompt({super.key, required this.geosphere});

  @override
  State<PhotoPrompt> createState() => _PhotoPromptState();
}

class _PhotoPromptState extends State<PhotoPrompt> {
  File? image;

  Future pickImage(
      ImageSource source, GalleryViewModel galleryViewModel) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      log("beofre");
      // Save the image path to the gallery
      galleryViewModel.addPhotoToGallery(
          widget.geosphere.geoSphereId, image.path);
      log("after");
      /*
      Provider.of<GalleryService>(context, listen: false)
          .uploadPhoto(widget.geoSphereId, imageTemporary);*/
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GeoSphereGallery(geoSphere: widget.geosphere),
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final galleryViewModel =
        Provider.of<GalleryViewModel>(context, listen: false);
    return AlertDialog(
      title: const Text("Add a photo!"),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery, galleryViewModel),
              child: const Text("Pick Gallery"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  var status = await Permission.camera.request();
                  if (status.isGranted) {
                    pickImage(ImageSource.camera, galleryViewModel);
                  } else {
                    print("bruh");
                  }
                } else if (Platform.isIOS) {
                  // TODO: Implement iOS camera permission
                  pickImage(ImageSource.camera, galleryViewModel);
                }
              },
              child: const Text("Pick Camera"),
            ),
          ],
        ),
      ),
    );
  }
}
