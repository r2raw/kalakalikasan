class RecyclableMaterials {
  const RecyclableMaterials({
    required this.waste_type,
    required this.material_name,
    required this.dirty,
    required this.clean,
    required this.minimumKg,
  });
  final String waste_type;
  final String material_name;
  final int dirty;
  final int clean;
  final int minimumKg;

  String get title {
    if (material_name.length > 25) {
      return '${material_name.substring(0, 25)}...';
    }

    return material_name;
  }
}
