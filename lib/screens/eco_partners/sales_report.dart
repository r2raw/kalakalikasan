import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/partners/accumulated_points.dart';
import 'package:kalakalikasan/widgets/partners/sales_trend.dart';
import 'package:kalakalikasan/widgets/partners/top_purchases_chart.dart';

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
        title: const Text('Reports'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AccumulatedPoints(),
              TopPurchasesChart(),
              SalesTrend(),
            ],
          ),
        ),
      ),
    );
  }
}
