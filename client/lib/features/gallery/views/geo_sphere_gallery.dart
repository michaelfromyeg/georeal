import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/view_model/gallery_view_model.dart';
import 'package:georeal/features/gallery/widgets/gallery_navbar.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:provider/provider.dart';

class GeoSphereGallery extends StatelessWidget {
  final GeoSphere geoSphere;

  const GeoSphereGallery({
    super.key,
    required this.geoSphere,
  });

  @override
  Widget build(BuildContext context) {
    final galleryViewModel = context.watch<GalleryViewModel>();
    List<String> photoUrls =
        galleryViewModel.getPhotosFromGallery(geoSphere.geoSphereId);

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            GalleryNavBar(
              geoSphere: geoSphere,
            ),
            ElevatedButton(
                onPressed: () {
                  galleryViewModel.fetchGallery(geoSphere.geoSphereId);
                },
                child: const Text("Fetch Gallery")),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 6,
                ),
                itemCount: photoUrls.length,
                itemBuilder: (context, index) {
                  String photoUrl = photoUrls[index];
                  return GestureDetector(
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ));
                      },
                    ),
                    onTap: () => _showFullSizeImage(context, photoUrl),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showFullSizeImage(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(photoUrl),
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
