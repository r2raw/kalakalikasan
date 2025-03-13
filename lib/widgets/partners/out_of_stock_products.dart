import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/partners/delete_product.dart';
import 'package:kalakalikasan/widgets/partners/edit_product.dart';

class OutOfStockProducts extends ConsumerStatefulWidget {
  const OutOfStockProducts(this.searchProduct, {super.key});
  final String searchProduct;

  @override
  ConsumerState<OutOfStockProducts> createState() {
    return _OutOfStockProducts();
  }
}

class _OutOfStockProducts extends ConsumerState<OutOfStockProducts> {
  void _deleteProduct(StoreProduct product) async {
    showDialog(context: context, builder: (ctx) => DeleteProduct(product));
  }

  void _editProduct(StoreProduct product) async {
    final result = await showModalBottomSheet<StoreProduct>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => EditProduct(product),
    );
    if (result == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = widget.searchProduct;

    final outOfStockProducts =
        ref.watch(myProductProvider.notifier).getOutOfStockProducts();

    List<StoreProduct> filteredProducts = outOfStockProducts
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
                  width: 70,
                  height: 70,
                ),
              if (filteredProducts[index].logo.isNotEmpty)
                Image.network(
                  'https://kalakalikasan-server.onrender.com/products/${filteredProducts[index].logo}',
                  width: 70,
                  height: 70,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/token-img.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          filteredProducts[index].price.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 33, 77, 44)),
                        )
                      ],
                    ),
                    Text(
                      filteredProducts[index].quantity.toString(),
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 33, 77, 44)),
                    )
                  ],
                ),
              ),
              Column(
                children: [
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
