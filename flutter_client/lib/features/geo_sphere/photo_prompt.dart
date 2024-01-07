import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPrompt extends StatefulWidget {
  const PhotoPrompt({super.key});

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
              onPressed: () => pickImage(ImageSource.camera),
              child: const Text("Pick Camera"),
            ),
          ],
        ),
      ),
    );
  }
}
