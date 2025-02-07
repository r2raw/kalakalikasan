import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';

class MyProductListScreen extends StatelessWidget {
  const MyProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
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
        width: w,
        height: h,
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(label: Text('Search Product')),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  // decoration: BoxDecoration(color: Colors.white),
                  child: ListView.builder(
                      itemCount: dummyProducts.length,
                      itemBuilder: (ctx, index) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            margin: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/product_sample.png',
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
                                        dummyProducts[index].title,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'assets/images/token-img.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            dummyProducts[index].price.toString(),
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Color.fromARGB(255, 32, 77, 44),
                                        backgroundColor: const Color.fromARGB(
                                            255, 209, 240, 210),
                                      ),
                                      onPressed: () {},
                                      child: Text('Edit'),
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.red),
                                        onPressed: () {},
                                        child: Text('Delete'))
                                  ],
                                )
                              ],
                            ),
                          )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
