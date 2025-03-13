import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/partners/delete_product.dart';
import 'package:kalakalikasan/widgets/partners/edit_product.dart';

class MyAvailableProducts extends ConsumerStatefulWidget {
  const MyAvailableProducts(this.searchProduct, {super.key});
  final String searchProduct;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyAvailableProduct();
  }
}

class _MyAvailableProduct extends ConsumerState<MyAvailableProducts> {
  void _deleteProduct(StoreProduct product) async {
    showDialog(context: context, builder: (ctx) => DeleteProduct(product));
  }

  void _editProduct(StoreProduct product) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => EditProduct(product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = widget.searchProduct;
    final availableProducts =
        ref.watch(myProductProvider.notifier).getAvailableProducts();
    List<StoreProduct> filteredProducts = availableProducts
        .where((product) =>
                product.productTitle
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                product.productId.toLowerCase().contains(
                    searchQuery.toLowerCase()) // ✅ Also search by product ID
            )
        .toList();

    Widget content = Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No products found!',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    ));
    if (filteredProducts.isNotEmpty) {
      content = ListView.builder(
        shrinkWrap: true,
        itemCount: filteredProducts.length,
        itemBuilder: (ctx, index) => Container(
          color: Theme.of(context).canvasColor,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.only(bottom: 2),
          // decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              if (filteredProducts[index].logo.isEmpty)
                Image.asset(
                  'assets/icons/basura_icon.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.fill,
                ),
              if (filteredProducts[index].logo.isNotEmpty)
                Image.network(
                  'https://kalakalikasan-server.onrender.com/products/${filteredProducts[index].logo}',
                  width: 60,
                  height: 60,
                  fit: BoxFit.fill,
                ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toTitleCase(filteredProducts[index].productTitle),
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 33, 77, 44),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ID: ${filteredProducts[index].productId}',
                      style: TextStyle(
                          fontSize: 14, color: Color.fromARGB(255, 33, 77, 44)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Price: ${filteredProducts[index].price}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 33, 77, 44)),
                        ),
                        Image.asset(
                          'assets/images/token-img.png',
                          width: 14,
                          height: 14,
                        ),
                      ],
                    ),
                    Text(
                      'Stocks: ${filteredProducts[index].quantity}',
                      style: TextStyle(
                          fontSize: 14, color: Color.fromARGB(255, 33, 77, 44)),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     foregroundColor: Color.fromARGB(255, 33, 77, 44),
                  //     backgroundColor: const Color.fromARGB(255, 209, 240, 210),
                  //   ),
                  //   onPressed: () {
                  //     _editProduct(filteredProducts[index]);
                  //   },
                  //   child: Text('Edit'),
                  // ),
                  IconButton(
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        // backgroundColor:
                        //     const Color.fromARGB(255, 209, 240, 210),
                      ),
                      onPressed: () {
                        _editProduct(filteredProducts[index]);
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () {
                        _deleteProduct(filteredProducts[index]);
                      },
                      icon: Icon(Icons.delete)),
                  // TextButton(
                  //     style: TextButton.styleFrom(foregroundColor: Colors.red),
                  //     onPressed: () {
                  //       _deleteProduct(filteredProducts[index]);
                  //     },
                  //     child: Text('Delete'))
                ],
              )
            ],
          ),
        ),
      );
    }
    return Card(
      clipBehavior: Clip.hardEdge,
      child: content,
    );
  }
}
