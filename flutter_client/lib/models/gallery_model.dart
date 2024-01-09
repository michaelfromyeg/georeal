class Gallery {
  final String id;
  List<String> photoPaths;

  Gallery({required this.id, List<String>? photoPaths})
      : photoPaths = photoPaths ?? []; // Modify this line

  // Methods to add, remove, or update photos in the gallery
}
