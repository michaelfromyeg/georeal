import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../gallery/services/gallery_service.dart';

class PhotoPrompt extends StatefulWidget {
  final String geoSphereId;
  const PhotoPrompt({super.key, required this.geoSphereId});

  @override
  State<PhotoPrompt> createState() => _PhotoPromptState();
}

class _PhotoPromptState extends State<PhotoPrompt> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;

      // Save the image path to the gallery
      Provider.of<GalleryService>(context, listen: false)
          .addPhotoToGallery(widget.geoSphereId, image.path);

      /*
      Provider.of<GalleryService>(context, listen: false)
          .uploadPhoto(widget.geoSphereId, imageTemporary);*/
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add a photo!"),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Text("Pick Gallery"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  var status = await Permission.camera.request();
                  if (status.isGranted) {
                    pickImage(ImageSource.camera);
                  } else {
                    print("bruh");
                  }
                } else if (Platform.isIOS) {
                  // TODO: Implement iOS camera permission
                  pickImage(ImageSource.camera);
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
