import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/order_request.dart';
import 'package:kalakalikasan/provider/order_request_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_partners/convert_ec.dart';
import 'package:kalakalikasan/screens/eco_partners/my_product_list.dart';
import 'package:kalakalikasan/screens/eco_partners/sales_report.dart';
import 'package:kalakalikasan/screens/eco_partners/trade_request.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';
import 'package:http/http.dart' as http;

class StoreDashboardNav extends ConsumerStatefulWidget {
  const StoreDashboardNav({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StoreDashboardNav();
  }
}

class _StoreDashboardNav extends ConsumerState<StoreDashboardNav> {
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    try {
      
    final url =
          Uri.https('kalakalikasan-server.onrender.com', 'pending-product-request/${ref.read(userStoreProvider)[UserStore.id]}');

      final response = await http.get(url);
      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<OrderRequest> loadedOrders = [];

        final orders = decoded['orders'];
        for (final order in orders) {
          loadedOrders.add(
            OrderRequest(
              order['order_id'],
              order['order_date'],
              order['ordered_by'],
              order['username'],
              order['status'],
            ),
          );
        }

        ref.read(orderRequestProvider.notifier).loadOrders(loadedOrders);
      }
    } catch (e) {
      setState(() {
        _error = 'Oops! something went wrong!';
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _error = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<OrderRequest> _orderList = ref.watch(orderRequestProvider);
    return Container(
      // padding: EdgeInsets.only(
      //   top: 20,
      // ),
      // decoration: BoxDecoration(color: Colors.white),
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
          Stack(
            children: [
              DashboardNavItem(
                icon: Icons.inventory_2_outlined,
                title: 'Product Request',
                screen: TradeRequestScreen(),
              ),
              if(_orderList.isNotEmpty)Positioned(
                  top: 0,
                  right: 35,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      _orderList.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
