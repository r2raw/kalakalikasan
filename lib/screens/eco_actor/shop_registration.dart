import 'package:flutter/material.dart';

class ShopRegistrationScreen extends StatelessWidget {
  const ShopRegistrationScreen({super.key});
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
          title: const Text('Shop Registration'),
        ),
        body: Container(
          height: h,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 233, 233, 233),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Register Your',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Store',
                      style: TextStyle(
                          color: Color.fromARGB(255, 38, 167, 72),
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TextField(
                          style:
                              TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 32, 77, 44),
                            label: Text(
                              'Store Name',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 32, 77, 44)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 38, 167, 72),
                                  width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 32, 77, 44),
                                  width: 2),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Store Address',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 32, 77, 44)),
                        ),
                        TextField(
                          style:
                              TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 32, 77, 44),
                            label: Text(
                              'Barangay Name',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 32, 77, 44)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 38, 167, 72),
                                  width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 32, 77, 44),
                                  width: 2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          style:
                              TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 32, 77, 44),
                            label: Text(
                              'Street Name',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 32, 77, 44)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 38, 167, 72),
                                  width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 32, 77, 44),
                                  width: 2),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Credentials',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 32, 77, 44)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                          onPressed: () {},
                          label: Text("Barangay Permit"),
                          icon: Icon(Icons.upload),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                          onPressed: () {},
                          label: Text("DTI Permit"),
                          icon: Icon(Icons.upload),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
