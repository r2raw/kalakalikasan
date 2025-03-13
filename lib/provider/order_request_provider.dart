import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/order_request.dart';

class OrderRequestNotifier extends StateNotifier<List<OrderRequest>> {
  OrderRequestNotifier() : super([]);

  void loadOrders(List<OrderRequest> requestedOrders) {
    state = requestedOrders;
  }

  void removeOrder(String orderId) {
    state = state.where((order) => order.orderId != orderId).toList();
  }
}

final orderRequestProvider =
    StateNotifierProvider<OrderRequestNotifier, List<OrderRequest>>((ref) {
  return OrderRequestNotifier();
});
