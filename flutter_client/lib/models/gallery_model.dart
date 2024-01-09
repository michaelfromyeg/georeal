class Gallery {
  final String id; // This can match the GeoSphere's name or a unique ID.
  final List<String> photoPaths;

  Gallery({required this.id, this.photoPaths = const []});

  // Methods to add, remove, or update photos in the gallery
}
