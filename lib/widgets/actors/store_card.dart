import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_actor/store_products.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => StoreProducts()));
      },
      child: Card(
        child: Column(
          children: [
            Icon(
              Icons.store,
              size: 100,
              color: Color.fromARGB(255, 32, 77, 44),
            ),
            Text(
              'Store name',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('4.0'),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(Icons.star_border)
              ],
            )
          ],
        ),
      ),
    );
  }
}
