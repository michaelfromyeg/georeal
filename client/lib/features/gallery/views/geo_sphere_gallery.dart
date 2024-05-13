import 'package:flutter/material.dart';
import 'package:georeal/features/gallery/view_model/gallery_view_model.dart';
import 'package:georeal/features/gallery/views/full_screen_image_viewer.dart';
import 'package:georeal/features/gallery/widgets/gallery_navbar.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/models/geo_sphere_model.dart';
import 'package:provider/provider.dart';

class GeoSphereGallery extends StatefulWidget {
  final GeoSphere geoSphere;

  const GeoSphereGallery({super.key, required this.geoSphere});

  @override
  _GeoSphereGalleryState createState() => _GeoSphereGalleryState();
}

class _GeoSphereGalleryState extends State<GeoSphereGallery> {
  late List<String> photoUrls;

  @override
  void initState() {
    super.initState();
    final galleryViewModel =
        Provider.of<GalleryViewModel>(context, listen: false);
    photoUrls =
        galleryViewModel.getPhotosFromGallery(widget.geoSphere.geoSphereId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            GalleryNavBar(
              geoSphere: widget.geoSphere,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
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
                          ),
                        );
                      },
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            FullScreenImageViewer(imageUrl: photoUrl),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
