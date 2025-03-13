import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/store_product.dart';

class MyProductNotifier extends StateNotifier<List<StoreProduct>> {
  MyProductNotifier() : super([]);

  void saveProducts(List<StoreProduct> products) {
    state = products;
  }

  void reset() {
    state = [];
  }

  void addProduct(StoreProduct product) {
    state = [...state, product]; 
  }

  void deleteProduct(String productId) {
    state = state.map((product) {
      if (product.productId == productId) {
        return StoreProduct(
          product.productId,
          product.productTitle,
          product.price,
          product.quantity,
          product.logo,
          "unavailable", 
        );
      }
      return product;
    }).toList();
  }

  void restoreProduct(String productId) {
    state = state.map((product) {
      if (product.productId == productId) {
        return StoreProduct(
          product.productId,
          product.productTitle,
          product.price,
          product.quantity,
          product.logo,
          "available", // Update status
        );
      }
      return product;
    }).toList();
  }

  void editProduct(StoreProduct updatedProduct) {
    state = state.map((product) {
      if (product.productId == updatedProduct.productId) {
        return updatedProduct; // Replace with new product data
      }
      return product;
    }).toList();
  }

  List<StoreProduct> getAvailableProducts() {
    return state
        .where(
            (product) => product.status == "available" && product.quantity > 0)
        .toList();
  }

  List<StoreProduct> getOutOfStockProducts() {
    return state
        .where(
            (product) => product.status == "available" && product.quantity == 0)
        .toList();
  }

  List<StoreProduct> getDeletedProducts() {
    return state.where((product) => product.status == "unavailable").toList();
  }
}

final myProductProvider =
    StateNotifierProvider<MyProductNotifier, List<StoreProduct>>((ref) {
  return MyProductNotifier();
});
