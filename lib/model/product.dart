class Product {
  const Product({required this.title, required this.price, required this.quantity});
  final String title;
  final double price;
  final int quantity;
}


class ProductTradeRequest {
  const ProductTradeRequest({required this.requestedProducts, required this.name});
  final List<Product> requestedProducts;
  final String name;

  double get grandTotal{

    double total = 0;

    for(final product in requestedProducts){
      double amount = product.price * product.quantity;
      total += amount;
    }


    return total;
  }
}