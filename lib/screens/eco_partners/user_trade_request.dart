import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/product.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/order_request_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class UserTradeRequestScreen extends ConsumerStatefulWidget {
  const UserTradeRequestScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserTradeRequestScreen();
  }
}

class _UserTradeRequestScreen extends ConsumerState<UserTradeRequestScreen> {
  Map<String, dynamic>? orderData;
  bool _isFetching = false;
  bool _isSending = false;
  List<String> _errors = [];
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadOrderData();
  }

  int getGrandTotal() {
    int totalPrice = 0;

    for (final product in orderData!['products']) {
      totalPrice += (product['price'] as int) * (product['quantity'] as int);
    }
    return totalPrice;
  }

  void _loadOrderData() async {
    try {
      setState(() {
        _isFetching = true;
      });
      final String orderId = widget.orderId;
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'product-request/$orderId');
      final response = await http.get(url);
      final decoded = json.decode(response.body);
      if (response.statusCode >= 400) {
        List<String> errors = decoded['errors'];
        setState(() {
          _errors = errors;
          _isFetching = false;
        });
        return;
      }
      if (response.statusCode == 200) {
        final order = decoded['order'];
        setState(() {
          _isFetching = false;
          orderData = order;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _rejectOrder() async {
    try {
      setState(() {
        _isSending = true;
      });

      // final url = Uri.https(
      //     'kalakalikasan-server.onrender.com', 'reject-product-request');

      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'reject-product-request');
      final response = await http.patch(url,
          headers: {"Content-type": "application/json"},
          body: json.encode({'orderId': widget.orderId}));
      final decoded = json.decode(response.body);

      if (response.statusCode >= 400) {
        setState(() {
          _error = decoded['error'];
          _isSending = false;
        });
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _error = null;
          });
        });
        return;
      }

      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });
        ref.read(orderRequestProvider.notifier).removeOrder(widget.orderId);
        if (!context.mounted) {
          return;
        }
      }
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops! Something went wrong, please try again later.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          )));
    }
  }

  void _acceptRequest() async {
    try {
      setState(() {
        _isSending = true;
      });
      // final url = Uri.https('kalakalikasan-server.onrender.com', 'accept-product-request');

      final url = Uri.https('kalakalikasan-server.onrender.com', 'accept-product-request');
      final response = await http.patch(url,
          headers: {"Content-type": "application/json"},
          body: json.encode({
            'orderId': widget.orderId,
            'owner_id': ref.read(currentUserProvider)[CurrentUser.id],
          }));
      final decoded = json.decode(response.body);

      if (response.statusCode >= 400) {
        setState(() {
          _error = decoded['error'];
          _isSending = false;
        });
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _error = null;
          });
        });
        return;
      }

      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });
        ref.read(orderRequestProvider.notifier).removeOrder(widget.orderId);
        if (!context.mounted) {
          return;
        }
      }
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops! Something went wrong, please try again later.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    Widget content = Center(
        child: Text(
      'No order found',
      style: TextStyle(color: Theme.of(context).primaryColor),
    ));
    if (_isFetching) {
      content = Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingLg(50),
          SizedBox(
            height: 12,
          ),
          Text(
            'Loading order data...',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ));
    }

    if (_errors.isNotEmpty) {
      content = Center(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final error in _errors)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    error,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                )
            ],
          ),
        ),
      );
    }
    if (orderData != null) {
      content = ClipPath(
        clipper: TicketClipper(),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Image.asset('assets/icons/basura_bot_text.png',
                    width: 96, height: 96),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      myDateTime(orderData!['order_date']),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Store',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      toTitleCase(orderData!['store_name']),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      orderData!['username'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 100,
                        child: Text(
                          textAlign: TextAlign.start,
                          'Item',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        )),
                    SizedBox(
                        width: 100,
                        child: Text(
                          textAlign: TextAlign.center,
                          'Qty',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        )),
                    SizedBox(
                        width: 100,
                        child: Text(
                          'Total',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderData!['products'].length,
                    itemBuilder: (ctx, index) => Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  toTitleCase(textTruncate(
                                      orderData!['products'][index]
                                          ['product_name'],
                                      10)),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/token-img.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    Text(
                                      orderData!['products'][index]['price']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              textAlign: TextAlign.center,
                              orderData!['products'][index]['quantity']
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/images/token-img.png',
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  (orderData!['products'][index]['price'] *
                                          orderData!['products'][index]
                                              ['quantity'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/token-img.png',
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(getGrandTotal().toString(),
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ],
                    )
                  ],
                ),
                if (orderData!['status'] == 'pending')
                  if (_isSending)
                    LoadingLg(50)
                  else
                    Column(
                      children: [
                        if (_error != null) ErrorSingle(errorMessage: _error),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(w, 50),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white),
                            onPressed: _acceptRequest,
                            child: Text('Accept')),
                        SizedBox(
                          height: 16,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              fixedSize: Size(w, 50),
                            ),
                            onPressed: _rejectOrder,
                            child: Text('Reject')),
                      ],
                    ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        title: const Text('Trade Request'),
      ),
      body: Container(
        // decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: content,
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 16.0;

    // Rounded rectangle shape
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    // Perforation settings
    double holeRadius = 10; // Adjust for better look
    double gap = 6; // Space between circles
    double sidePadding = 16; // Left and Right padding

    Path holes = Path();
    for (double x = sidePadding;
        x < size.width - sidePadding;
        x += holeRadius * 2 + gap) {
      holes.addOval(Rect.fromCircle(
        center: Offset(x + holeRadius, size.height),
        radius: holeRadius,
      ));
    }

    return Path.combine(PathOperation.difference, path, holes);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
