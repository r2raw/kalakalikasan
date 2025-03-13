import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/partners/restore_product.dart';

class DeletedProducts extends ConsumerStatefulWidget {
  const DeletedProducts(this.searchProduct, {super.key});
  final String searchProduct;
  @override
  ConsumerState<DeletedProducts> createState() {
    return _DeleteProduct();
  }
}

class _DeleteProduct extends ConsumerState<DeletedProducts> {
  void _RestoreProduct(StoreProduct product) async {
    showDialog(context: context, builder: (ctx) => RestoreProduct(product));
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = widget.searchProduct;
    final deletedProducts =
        ref.watch(myProductProvider.notifier).getDeletedProducts();
    List<StoreProduct> filteredProducts = deletedProducts
        .where((product) =>
            product.productTitle
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            product.productId.toLowerCase().contains(searchQuery.toLowerCase()))
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
                  IconButton(
                    style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      _RestoreProduct(filteredProducts[index]);
                    },
                    icon: Icon(Icons.settings_backup_restore),
                  ),
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
