class Product {
    Product({
    required this.productId,
    required this.title,
    required this.price,
    required this.logo,
    // Remove `final` here so you can update `quantity`
    this.quantity = 0,
  });


  final String productId;
  final String title;
  final int price;
  int quantity;
  final String logo;
}

class StoreProduct {
  StoreProduct(
      {required this.storeId, required this.storeName, required this.items});

  final String storeId;
  final String storeName;
  final List<Product> items;
}

class ProductTradeRequest {
  const ProductTradeRequest(
      {required this.requestedProducts, required this.name});
  final List<Product> requestedProducts;
  final String name;

  double get grandTotal {
    double total = 0;

    for (final product in requestedProducts) {
      int amount = product.price * product.quantity;
      total += amount;
    }

    return total;
  }
}
