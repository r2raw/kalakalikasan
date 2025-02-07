import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/product.dart';

class UserTradeRequestScreen extends StatelessWidget {
  const UserTradeRequestScreen({super.key, required this.userRequest});
  final ProductTradeRequest userRequest;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
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
        title: const Text('Trade Request'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Text(
                  userRequest.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userRequest.requestedProducts.length,
                    itemBuilder: (ctx, index) => Container(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/product_sample.png',
                            width: 80,
                            height: 80,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userRequest.requestedProducts[index].title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/token-img.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${userRequest.requestedProducts[index].price} * ${userRequest.requestedProducts[index].quantity}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text((userRequest.requestedProducts[index].price *
                                  userRequest.requestedProducts[index].quantity)
                              .toString(), style: TextStyle(fontSize: 20),),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.remove,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/token-img.png',
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(userRequest.grandTotal.toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(w, 50),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () {},
                    child: Text('Accept')),
                SizedBox(
                  height: 16,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      fixedSize: Size(w, 50),
                    ),
                    onPressed: () {},
                    child: Text('Reject'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
