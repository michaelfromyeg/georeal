import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/widgets/photo_prompt.dart';
import 'package:georeal/models/geo_sphere_model.dart';

/// Toast that notifies the user when they enter a GeoSphere

class CustomToast {
  static void show(BuildContext context, String message, GeoSphere geoSphere) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green[200],
            ),
            padding: const EdgeInsets.all(10),
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return PhotoPrompt(
                              geoSphereId: geoSphere.geoSphereId,
                            );
                          }));
                    },
                    child: const Text("Button"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Dismiss the toast after a certain duration
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
