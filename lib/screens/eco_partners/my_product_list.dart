import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/partners/add_product.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/partners/delete_product.dart';
import 'package:kalakalikasan/widgets/partners/deleted_products.dart';
import 'package:kalakalikasan/widgets/partners/edit_product.dart';
import 'package:kalakalikasan/widgets/partners/my_available_products.dart';
import 'package:kalakalikasan/widgets/partners/out_of_stock_products.dart';

class MyProductListScreen extends ConsumerStatefulWidget {
  const MyProductListScreen({super.key});
  @override
  ConsumerState<MyProductListScreen> createState() {
    return _MyProductListScreen();
  }
}

class _MyProductListScreen extends ConsumerState<MyProductListScreen> {
  bool _isFetching = false;
  String _searchQuery = "";
  String selectedType = '';
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final storeId = ref.read(userStoreProvider)[UserStore.id];

      // final url = Uri.https(
      //     'kalakalikasan-server.onrender.com', 'fetch-products/$storeId');

      final url = Uri.https('kalakalikasan-server.onrender.com', 'fetch-products/$storeId');
      setState(() {
        _isFetching = true;
      });
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final products = decoded['products'];
        List<StoreProduct> loadedProducts = [];
        for (final item in products) {
          loadedProducts.add(StoreProduct(
              item['id'],
              item['productName'],
              item['price'],
              item['quantity'],
              item['productImage'] ?? '',
              item['status']));
        }

        ref.read(myProductProvider.notifier).saveProducts(loadedProducts);
        setState(() {
          _isFetching = false;
        });
      }
    } catch (e, stackTrace) {
      print('error: $stackTrace');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ooops! Something went wrong')));
    }
  }


  void addProduct() async {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (ctx) => AddProduct()));

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => AddProduct(),
    );

    if (result == null) {
      print('prod $result');
      return;
    }

    print('prod: ${result}');

    // if (result['status'] == 'existing') {
    //   final productRes = result['product'];
    //   final updatedList = productList;

    //   final productIndex = updatedList.indexWhere(
    //     (product) => product.productId == productRes['productId'],
    //   );

    //   if (productIndex != -1) {
    //     // Convert the 'quantity' from the response to an int.
    //     // If it's already an int, just remove `int.parse`.
    //     setState(() {
    //       updatedList[productIndex].quantity = productRes['quantity'];
    //     });
    //   }
    // }
    // if (result['status'] == 'not existing') {
    //   setState(() {
    //     productList.add(result['product']);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final storeProducts = ref.watch(myProductProvider);
    Widget content = Center(
        child: Text('No products found!',
            style: TextStyle(
              color: Color.fromARGB(255, 32, 77, 44),
            )));
    if (_isFetching) {
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingLg(50),
          SizedBox(
            height: 12,
          ),
          Text(
            'Loading store products...',
            style: TextStyle(
              color: Color.fromARGB(255, 32, 77, 44),
            ),
          )
        ],
      );
    }
    if (storeProducts.isNotEmpty) {
      content = MyAvailableProducts(_searchQuery);
    }

    if(storeProducts.isNotEmpty && selectedType == 'out_of_stocks'){
      content = OutOfStockProducts(_searchQuery);
    }
    if(storeProducts.isNotEmpty && selectedType == 'deleted'){
      content = DeletedProducts(_searchQuery);
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
        actions: [IconButton(onPressed: addProduct, icon: Icon(Icons.add))],
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(label: Text('Search Product')),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedType == ''
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          foregroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        setState(() {
                          selectedType = '';
                        });
                      },
                      child: Text('Available products')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == 'out_of_stocks'
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        selectedType = 'out_of_stocks';
                      });
                    },
                    child: Text('Out of stocks'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: selectedType == 'deleted'
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        selectedType = 'deleted';
                      });
                    },
                    child: Text('Deleted Products'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    _loadProducts(); // Reload products when user pulls down
                  },
                  child: content),
            )
          ],
        ),
      ),
    );
  }
}
