import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_actor/collection_schedules.dart';
import 'package:kalakalikasan/screens/eco_actor/conversion_rates.dart';
import 'package:kalakalikasan/screens/eco_actor/more.dart';
import 'package:kalakalikasan/screens/eco_actor/nearby_stations.dart';
import 'package:kalakalikasan/screens/eco_actor/partner_stores.dart';
import 'package:kalakalikasan/screens/eco_actor/point_exchange.dart';
import 'package:kalakalikasan/screens/eco_actor/referral.dart';
import 'package:kalakalikasan/screens/eco_actor/user_transactions.dart';
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
      children: const [
        DashboardNavItem(
          icon: Icons.star_border,
          title: 'Exchange Points',
          screen: PointExchangeScreen(),
        ),
        DashboardNavItem(
          icon: Icons.store_mall_directory_outlined,
          title: 'Eco-Partner Stores',
          screen: PartnerStoresScreen(),
        ),
        DashboardNavItem(
          icon: Icons.pin_drop,
          title: 'Nearby Stations',
          screen: NearbyStationScreen(),
        ),
        DashboardNavItem(
          icon: Icons.compare_arrows_outlined,
          title: 'Conversion Rates',
          screen: ConversionRatesScreen(),
        ),
        DashboardNavItem(
          icon: Icons.calendar_month,
          title: 'Collection Schedules',
          screen: CollectionSchedulesScreen(),
        ),
        DashboardNavItem(
          icon: Icons.featured_play_list_sharp,
          title: 'Transactions',
          screen: UserTransactionsScreen(),
        ),
        DashboardNavItem(
          icon: Icons.favorite,
          title: 'Invite a friend',
          screen: ReferralScreen(),
        ),
        DashboardNavItem(
          icon: Icons.more_horiz,
          title: 'More',
          screen: MoreScreen(),
        ),
      ],
    );
  }
}
