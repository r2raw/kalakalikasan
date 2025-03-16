import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/product.dart';
import 'package:kalakalikasan/model/store.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/actor_product_list.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/actors/cart_button.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class StoreProducts extends ConsumerStatefulWidget {
  const StoreProducts({super.key, required this.storeInfo});
  final Store storeInfo;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StoreProducts();
  }
}

class _StoreProducts extends ConsumerState<StoreProducts> {
  List<Product> productList = [];
  bool _isFetching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final storeInfo = widget.storeInfo;

    try {
      setState(() {
        _isFetching = true;
      });

      final url = Uri.https('kalakalikasan-server.onrender.com',
          'fetch-available-products/${storeInfo.storeId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final loadedProducts = decoded['products'];
        List<Product> productCopy = [];
        for (final product in loadedProducts) {
          print('quantity ${product['quantity']}');
          productCopy.add(Product(
              productId: product['id'],
              title: product['productName'],
              price: product['price'],
              quantity: product['quantity'],
              logo: product['productImage'] ?? ''));
        }

        setState(() {
          productList = productCopy;
          _isFetching = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
        'Ooops! Something went wrong',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final filteredProducts = productList;
    final storeInfo = widget.storeInfo;
    Widget content = Center(
      child: Text('No products listed yet!'),
    );

    if (_isFetching) {
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingLg(50),
          SizedBox(
            height: 12,
          ),
          Text('Loading poducts...'),
        ],
      );
    }
    if (productList.isNotEmpty) {
      content = Stack(
        children: [
          ActorProductList(productList: filteredProducts, storeInfo: storeInfo),
          Positioned(bottom: 30, right: 10, child: CartButton())
        ],
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
        title: const Text('Store Products'),
      ),
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        size: 60,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        storeInfo.storeName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('Search Product Name'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
