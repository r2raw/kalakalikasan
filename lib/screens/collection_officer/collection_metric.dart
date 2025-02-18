import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/under_construction.dart';

class CollectionMetricScreen extends StatelessWidget {
  const CollectionMetricScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: UnderConstruction());
  }
}
