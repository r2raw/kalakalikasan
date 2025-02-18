import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/util/text_truncate.dart';

class CartButton extends ConsumerStatefulWidget {
  const CartButton({super.key});
  @override
  ConsumerState<CartButton> createState() {
    return _CartButton();
  }
}

class _CartButton extends ConsumerState<CartButton> {
  List cart = [];
  @override
  void initState() {
    super.initState();

    // final cartData = ref.watch(cartProvider);
    final cartData = dummyCart;

    print(cartData);
    setState(() {
      cart = cartData;
    });
  }

  void _openCartModal() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        context: context,
        builder: (ctx) => Container(
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
                                cart[index]['store_name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              for (final product in cart[index]['items'])
                                Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_basket,
                                      size: 60,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          textTruncate(
                                              product['item_name'], 10),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
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
                                              (product['price'] *
                                                      product['quantity'])
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
                                            onPressed: () {},
                                            icon: Icon(Icons.add)),
                                        Text(product['quantity'].toString()),
                                        IconButton(
                                            onPressed: () {},
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
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 34, 76, 43),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Check out',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
        bottom: 10,
        right: 10,
        child: InkWell(
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
        ));
  }
}
