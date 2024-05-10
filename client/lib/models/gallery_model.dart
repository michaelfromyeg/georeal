class Gallery {
  final int id;
  List<String> photoPaths;

  Gallery({required this.id, List<String>? photoPaths})
      : photoPaths = photoPaths ?? [];
}
