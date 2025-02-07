import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/partners/store_dashboard_nav.dart';
import 'package:kalakalikasan/widgets/partners/store_info_btn.dart';

class MyShopScreen extends StatelessWidget {
  const MyShopScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StoreInfoBtn(),
        SizedBox(
          height: 20,
        ),
        StoreDashboardNav(),
      ],
    );
  }
}
