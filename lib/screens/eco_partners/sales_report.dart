import 'package:flutter/material.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({super.key});

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
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 233, 233)
        ),
      ),
    );
  }
}
