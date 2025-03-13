import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/model/product.dart';
import 'package:kalakalikasan/model/store.dart';
import 'package:kalakalikasan/provider/cart_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';

class ActorProductList extends ConsumerStatefulWidget {
  const ActorProductList({
    super.key,
    required this.productList,
    required this.storeInfo,
  });
  final Store storeInfo;
  final List<Product> productList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _ActorProductList();
  }
}

class _ActorProductList extends ConsumerState<ActorProductList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _addProduct(Product product) {
    final Store storeInfo = widget.storeInfo;

    final cartProductQuantity = ref
        .read(cartProvider.notifier)
        .getProductCartQuantity(storeInfo.storeId, product.productId);

    print('quantity: ${cartProductQuantity.toString()} || ${product.quantity}');

    if (cartProductQuantity == product.quantity) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content:  Text(
            'You have added the maximum available stock of this product to your cart.',
            style: TextStyle(color:  Theme.of(context).colorScheme.error)
          ),
        ),
      );
      return;
    }
    final Map<String, dynamic> productItem = {
      'store_id': storeInfo.storeId,
      'store_name': storeInfo.storeName,
      'products': {
        'product_id': product.productId,
        'product_image': product.logo,
        'product_name': product.title,
        'stocks': product.quantity,
        'quantity': 1,
        'price': product.price
      }
    };

    ref.read(cartProvider.notifier).addToCart(productItem);
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> productList = widget.productList;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: GridView.builder(
          itemCount: productList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (ctx, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _addProduct(productList[index]);
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 233, 233)),
                      child: productList[index].logo.isNotEmpty
                          ? Image.network(
                              'https://kalakalikasan-server.onrender.com/products/${productList[index].logo}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/product_sample.png',
                              width: 50,
                              height: 50,
                            ),
                    ),
                  ),
                  Text(productList[index].title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/token-img.png',
                        width: 20,
                        height: 20,
                      ),
                      Text(productList[index].price.toString())
                    ],
                  )
                ],
              )),
    );
  }
}
