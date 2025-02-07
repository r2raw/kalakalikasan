import 'package:flutter/material.dart';

class MyStoreInfo extends StatelessWidget {
  const MyStoreInfo({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Store Info'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color.fromARGB(70, 72, 114, 50),
                      ),
                      child: Icon(Icons.store_mall_directory_outlined),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tindahan Ni Aling Nena",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('Shop ID: 0000000001')
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: w,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'BLK #1 LOT 1, San Bartolome, Quezon City',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: w,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Number',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '09123123123',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: w,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'nenastore@gmail.com',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(w, 50),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () {},
                child: Text('Edit')),
            SizedBox(
              height: 20,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    fixedSize: Size(w, 50), foregroundColor: Colors.red),
                onPressed: () {},
                child: Text('Delete'))
          ],
        ),
      ),
    );
  }
}
