import 'package:kalakalikasan/util/validation.dart';

class OrderRequest {
  const OrderRequest(
      this.orderId, this.dateOrdered, this.orderedBy, this.username, this.status);
  final String orderId;
  final Map<String, dynamic> dateOrdered;
  final String orderedBy;
  final String username;
  final String status;

  String get formattedDate {
    return timeAgo(dateOrdered);
  }
}
