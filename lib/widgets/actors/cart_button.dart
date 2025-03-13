import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/provider/cart_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/widgets/actors/cart_list.dart';

class CartButton extends ConsumerStatefulWidget {
  const CartButton({super.key});
  @override
  ConsumerState<CartButton> createState() {
    return _CartButton();
  }
}

class _CartButton extends ConsumerState<CartButton> {
  void _openCartModal() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (ctx) => CartList()
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final cart = ref.watch(cartProvider);

    // Compute the total number of products
    final numberOfProducts =
        ref.read(cartProvider.notifier).countTotalProducts();
    return Stack(
      children: [
        InkWell(
          onTap: _openCartModal,
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromARGB(255, 32, 77, 44)),
              child: Icon(
                Icons.shopping_cart,
                size: 40,
                color: Colors.white,
              )),
        ),
        if (numberOfProducts > 0)
          Positioned(
              top: -5,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  numberOfProducts.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ))
      ],
    );
  }
}
