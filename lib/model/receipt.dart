

class MaterialItem {
  const MaterialItem(this.materialName, this.pointsCollected, this.grams);
  final String materialName;
  final int pointsCollected;
  final int grams;
}

class Receipt {
  const Receipt(this.transactionId, this.transactionDate, this.total, this.materials);
  final String transactionId;
  final Map<String, dynamic> transactionDate;
  final int total;
  final List<MaterialItem> materials;
}