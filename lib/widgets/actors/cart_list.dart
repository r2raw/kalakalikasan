import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/product.dart';
import 'package:kalakalikasan/provider/cart_provider.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/points_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class CartList extends ConsumerStatefulWidget {
  @override
  ConsumerState<CartList> createState() {
    // TODO: implement createState
    return _CartList();
  }
}

class _CartList extends ConsumerState<CartList> {
  String? _error;
  List _errorArr = [];
  bool _isSending = false;
  void _addProduct(String storeId, String productId, int stocks) {
    final cartProductQuantity = ref
        .read(cartProvider.notifier)
        .getProductCartQuantity(storeId, productId);
    if (cartProductQuantity == stocks) {
      setState(() {
        _error =
            'You have added the maximum available stock of this product to your cart.';
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _error = null;
        });
      });
      return;
    }
    ref.read(cartProvider.notifier).addQuantity(storeId, productId);
  }

  void _decreaseProduct(String storeId, String productId) {
    ref.read(cartProvider.notifier).minusQuantity(storeId, productId);
  }

  void _onCheckOut() async {
    try {
      if (ref.read(cartProvider.notifier).getTotalPrice() <= 0) {
        setState(() {
          _error = 'Your cart is empty! Add some items before checking out.';
        });

        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _error = null;
          });
        });
        return;
      }

      if (ref.read(cartProvider.notifier).getTotalPrice() >
          ref.read(pointsProvider)) {
        setState(() {
          _error =
              'Insufficient points. Exchange PET bottles or cans to earn more points.';
        });

        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _error = null;
          });
        });
        return;
      }

      setState(() {
        _isSending = true;
      });

      final cart = ref.read(cartProvider);
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'checkout-products');
      final user_id = ref.read(currentUserProvider)[CurrentUser.id];
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode({'user_id': user_id, "cart": cart}),
      );

      final decoded = json.decode(response.body);
      if (response.statusCode >= 400) {
        final errors = decoded['errors'];
        print('errors: ${errors is List}');
        setState(() {
          _isSending = false;
          _errorArr = errors;
        });
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _errorArr = [];
          });
        });

        return;
      }

      if (response.statusCode == 200) {
        setState(() {
          _isSending = false;
        });
        final totalPrice = ref.read(cartProvider.notifier).getTotalPrice();
        final currentPoints =  ref.read(pointsProvider);
        final updatedPoints = currentPoints - totalPrice;
        ref.read(pointsProvider.notifier).updatePoints(updatedPoints);
        ref.read(cartProvider.notifier).reset();
        if (!context.mounted) {
          return;
        }

        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong!';
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _error = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List cart = ref.watch(cartProvider);
    return Container(
      // height: 600,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Center(
          child: Column(
        children: [
          Text(
            'Your cart',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            // height: 500,
            child: Container(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (ctx, index) => Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toTitleCase(cart[index]['store_name']),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (final product in cart[index]['products'])
                        Row(
                          children: [
                            if (product['product_image'].isEmpty)
                              Image.asset(
                                'assets/icons/basura_icon.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            if (product['product_image'].isNotEmpty)
                              Image.network(
                                'https://kalakalikasan-server.onrender.com/products/${product['product_image']}',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  toTitleCase(textTruncate(
                                      product['product_name'], 10)),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/token-img.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    Text(
                                      (product['price'] * product['quantity'])
                                          .toString(),
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _addProduct(
                                          cart[index]['store_id'],
                                          product['product_id'],
                                          product['stocks']);
                                    },
                                    icon: Icon(Icons.add)),
                                Text(product['quantity'].toString()),
                                IconButton(
                                    onPressed: () {
                                      _decreaseProduct(cart[index]['store_id'],
                                          product['product_id']);
                                    },
                                    icon: Icon(Icons.remove))
                              ],
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/token-img.png',
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      ref
                          .read(cartProvider.notifier)
                          .getTotalPrice()
                          .toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                )
              ],
            ),
          ),
          if (_errorArr.isNotEmpty)
            Column(
              children: [
                for (final error in _errorArr)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer),
                    child: Text(error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        )),
                  ),
              ],
            ),
          if (_error != null)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer),
              child: Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          SizedBox(
            height: 8,
          ),
          if (_isSending) LoadingLg(30),
          if (!_isSending)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 34, 76, 43),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _onCheckOut,
              child: const Text(
                'Check out',
                style: TextStyle(color: Colors.white),
              ),
            )
        ],
      )),
    );
  }
}
