import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  void addToCart(Map<String, dynamic> product) {
    String storeId = product['store_id'];
    List<Map<String, dynamic>> updatedCart = List.from(state);

    // Find if the store already exists
    int storeIndex =
        updatedCart.indexWhere((store) => store['store_id'] == storeId);

    if (storeIndex != -1) {
      List<Map<String, dynamic>> products =
          List.from(updatedCart[storeIndex]['products'] ?? []);
      Map<String, dynamic> newProduct = product['products'];

      int itemIndex = products
          .indexWhere((item) => item['product_id'] == newProduct['product_id']);

      if (itemIndex != -1) {
        products[itemIndex]['quantity'] += newProduct['quantity'];
      } else {
        products.add(newProduct);
      }

      updatedCart[storeIndex]['products'] = products;
    } else {
      updatedCart.add({
        'store_id': product['store_id'],
        'store_name': product['store_name'],
        'products': [product['products']],
      });
    }

    state = updatedCart;
  }

  int countTotalProducts() {
    int totalProducts = 0;

    for (var store in state) {
      if (store.containsKey('products') && store['products'] is List) {
        totalProducts += (store['products'] as List).length;
      }
    }

    return totalProducts;
  }

  int getProductCartQuantity(String storeId, String productId) {
    List<Map<String, dynamic>> updatedCart = List.from(state);
    int quantity = 0;
    int storeIndex =
        updatedCart.indexWhere((store) => store['store_id'] == storeId);
    if (storeIndex != -1) {
      List<Map<String, dynamic>> products =
          List.from(updatedCart[storeIndex]['products'] ?? []);
      int itemIndex =
          products.indexWhere((item) => item['product_id'] == productId);

      if (itemIndex != -1) {
        quantity = products[itemIndex]['quantity'];
      }
    }

    return quantity;
  }

  void addQuantity(String storeId, String productId) {
    List<Map<String, dynamic>> updatedCart = List.from(state);

    int storeIndex =
        updatedCart.indexWhere((store) => store['store_id'] == storeId);
    if (storeIndex != -1) {
      List<Map<String, dynamic>> products =
          List.from(updatedCart[storeIndex]['products'] ?? []);
      int itemIndex =
          products.indexWhere((item) => item['product_id'] == productId);

      if (itemIndex != -1) {
        products[itemIndex]['quantity'] += 1;
        updatedCart[storeIndex]['products'] = products;
        state = List.from(updatedCart);
      }
    }
  }

  void minusQuantity(String storeId, String productId) {
    List<Map<String, dynamic>> updatedCart = List.from(state);

    int storeIndex =
        updatedCart.indexWhere((store) => store['store_id'] == storeId);
    if (storeIndex != -1) {
      List<Map<String, dynamic>> products =
          List.from(updatedCart[storeIndex]['products'] ?? []);
      int itemIndex =
          products.indexWhere((item) => item['product_id'] == productId);

      if (itemIndex != -1 && products[itemIndex]['quantity'] > 1) {
        products[itemIndex]['quantity'] -= 1;
      } else if (itemIndex != -1) {
        products.removeAt(itemIndex);
      }

      if (products.isEmpty) {
        updatedCart.removeAt(storeIndex);
      } else {
        updatedCart[storeIndex]['products'] = products;
      }

      state = List.from(updatedCart);
    }
  }

  // double getTotalPrice() {
  //   double totalPrice = 0.0;
  //   for (var store in state) {
  //     if (store.containsKey('products') && store['products'] is List) {
  //       for (var product in store['products']) {
  //         totalPrice += (product['price'] * product['quantity']);
  //       }
  //     }
  //   }
  //   return totalPrice;
  // }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var store in state) {
      if (store.containsKey('products') && store['products'] is List) {
        for (var product in store['products']) {
          totalPrice +=
              (product['price'] as int) * (product['quantity'] as int);
        }
      }
    }
    return totalPrice;
  }

  void reset() {
    state = [];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});
