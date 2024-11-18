import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';

class DashboardNav extends StatelessWidget {
  const DashboardNav({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      children: [
        DashboardNavItem(),
        DashboardNavItem(),
        DashboardNavItem(),
        DashboardNavItem(),
        DashboardNavItem(),
        DashboardNavItem(),
        DashboardNavItem(),
        DashboardNavItem(),
      ],
    );
  }
}
