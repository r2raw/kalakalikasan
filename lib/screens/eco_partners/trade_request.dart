import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/screens/eco_partners/user_trade_request.dart';

class TradeRequestScreen extends StatelessWidget {
  const TradeRequestScreen({super.key});

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
        title: const Text('Trade Request'),
      ),
      body: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: dummyProductRequest.length,
                      itemBuilder: (ctx, index) => Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(color: Colors.white),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sell_outlined,
                                  size: 60,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dummyProductRequest[index].name,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/token-img.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            dummyProductRequest[index]
                                                .grandTotal
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (index + 1).toString() + ' hrs ago.',
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.check,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                UserTradeRequestScreen(
                                              userRequest:
                                                  dummyProductRequest[index],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
