import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalakalikasan/screens/collection_officer/collect_materials.dart';
import 'package:kalakalikasan/screens/eco_actor/officer_claim_receipt.dart';
import 'package:kalakalikasan/screens/eco_actor/user_transactions.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/widgets/actors/recycle_tips_slides.dart';
class HomeOfficer extends StatelessWidget {
  const HomeOfficer({super.key});
  @override
  Widget build(BuildContext context) {
    // const LatLng _pGooglePlex = LatLng(14.648282, 121.049850);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20 ),
      child: Column(
        children: [
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            shrinkWrap: true,
            children: const [
              DashboardNavItem(
                  icon: FontAwesome.recycle_solid,
                  title: 'Collect Materials',
                  screen: CollectMaterialsScreen()),
              DashboardNavItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Claim Receipt',
                  screen: OfficerClaimReceiptScreen()),
              DashboardNavItem(
                  icon: HeroIcons.arrow_path,
                  title: 'Transactions',
                  screen: UserTransactionsScreen()),
            ],
          ),
          RecycleTipsSlides(),
          // Container(
          //   width: double.infinity,
          //   height: 300,
          //   child: GoogleMap(
          //     initialCameraPosition: CameraPosition(
          //       target: _pGooglePlex,
          //       zoom: 15,
          //     ),
          //     markers: {
          //       Marker(
          //           markerId: MarkerId("_currLoc"),
          //           icon: BitmapDescriptor.defaultMarker,
          //           position: _pGooglePlex)
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
