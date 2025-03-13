import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/shop_registration.dart';
import 'package:kalakalikasan/screens/eco_actor/nearby_stations.dart';
import 'package:kalakalikasan/screens/eco_actor/partner_stores.dart';
import 'package:kalakalikasan/screens/eco_actor/point_exchange.dart';
import 'package:kalakalikasan/screens/eco_actor/referral.dart';
import 'package:kalakalikasan/screens/eco_actor/user_transactions.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';

class DashboardNav extends ConsumerWidget {
  const DashboardNav({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.read(currentUserProvider)[CurrentUser.role];
    return GridView(
      padding: EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: role == 'actor' ? 4 : 3, 
          mainAxisSpacing: 8),
      children: [
        DashboardNavItem(
          icon: Icons.qr_code,
          title: 'My QR',
          screen: PointExchangeScreen(),
        ),
        DashboardNavItem(
          icon: Icons.store_mall_directory_outlined,
          title: 'Eco-Partner Stores',
          screen: PartnerStoresScreen(),
        ),
        // DashboardNavItem(
        //   icon: Icons.pin_drop,
        //   title: 'Nearby Stations',
        //   screen: NearbyStationScreen(),
        // ),
        // DashboardNavItem(
        //   icon: Icons.compare_arrows_outlined,
        //   title: 'Conversion Rates',
        //   screen: ConversionRatesScreen(),
        // ),
        DashboardNavItem(
          icon: Icons.featured_play_list_sharp,
          title: 'Transactions',
          screen: UserTransactionsScreen(),
        ),
        // DashboardNavItem(
        //   icon: Icons.favorite,
        //   title: 'Invite a friend',
        //   screen: ReferralScreen(),
        // ),
        if (role == 'actor')
          DashboardNavItem(
            icon: Icons.storefront_outlined,
            title: 'Shop Registration',
            screen: ShopRegistrationScreen(),
          ),
      ],
    );
  }
}
