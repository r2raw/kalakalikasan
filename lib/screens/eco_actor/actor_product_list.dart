import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';

class ActorProductList extends StatelessWidget {
  const ActorProductList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: GridView.builder(
            itemCount: dummyProducts.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (ctx, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 233, 233)),
                      child: Image.asset(
                        'assets/images/product_sample.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(dummyProducts[index].title),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/token-img.png',
                          width: 20,
                          height: 20,
                        ),
                        Text(dummyProducts[index].price.toString())
                      ],
                    )
                  ],
                )),
      ),
    );
  }
}
