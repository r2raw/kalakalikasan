import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_partners/convert_ec.dart';
import 'package:kalakalikasan/screens/eco_partners/my_product_list.dart';
import 'package:kalakalikasan/screens/eco_partners/sales_report.dart';
import 'package:kalakalikasan/screens/eco_partners/trade_request.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';

class StoreDashboardNav extends StatelessWidget {
  const StoreDashboardNav({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 30,),
      decoration: BoxDecoration(color: Colors.white),
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        shrinkWrap: true,
        children: [
          DashboardNavItem(
            icon: Icons.inventory_2_outlined,
            title: 'Product List',
            screen: MyProductListScreen(),
          ),
          DashboardNavItem(
            icon: Icons.pie_chart_outline,
            title: 'Reports',
            screen: SalesReportScreen(),
          ),
          DashboardNavItem(
            icon: Icons.currency_exchange,
            title: 'Convert EC',
            screen: ConvertEcScreen(),
          ),
          DashboardNavItem(
            icon: Icons.inventory_2_outlined,
            title: 'Trade Request',
            screen: TradeRequestScreen(),
          ),
        ],
      ),
    );
  }
}
