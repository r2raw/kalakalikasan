import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/screens/eco_actor/actor_product_list.dart';
import 'package:kalakalikasan/widgets/under_construction.dart';

class StoreProducts extends StatelessWidget {
  const StoreProducts({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        'Store name',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('Enter Product Name'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ActorProductList(),
          ],
        ),
      ),
    );
  }
}
