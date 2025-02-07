import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/officers/reciept_column.dart';

class CollectedWasteRecieptScreen extends StatelessWidget {
  const CollectedWasteRecieptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Collected Waste Reciept'),
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
      ),
      body: Container(
          height: h,
          width: w,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 233, 233, 233),
          ),
          child: Center(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Juan Dela Cruz',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RecieptColumn()
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
