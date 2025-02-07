import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalakalikasan/screens/collection_officer/collection_metric.dart';
import 'package:kalakalikasan/screens/eco_actor/collection_schedules.dart';
import 'package:kalakalikasan/screens/eco_actor/user_transactions.dart';
import 'package:kalakalikasan/screens/login.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';

class HomeOfficer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    const LatLng _pGooglePlex = LatLng(14.648282, 121.049850);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, ),
      child: Column(
        children: [
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            shrinkWrap: true,
            children: [
              DashboardNavItem(
                  icon: Icons.stacked_line_chart_sharp,
                  title: 'Collection Metric',
                  screen: CollectionMetricScreen()),
              DashboardNavItem(
                  icon: Icons.calendar_month,
                  title: 'Collection Schedule',
                  screen: CollectionSchedulesScreen()),
              DashboardNavItem(
                  icon: Icons.featured_play_list_sharp,
                  title: 'Transactions',
                  screen: UserTransactionsScreen()),
            ],
          ),
          Container(
            width: double.infinity,
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _pGooglePlex,
                zoom: 15,
              ),
              markers: {
                Marker(
                    markerId: MarkerId("_currLoc"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex)
              },
            ),
          )
        ],
      ),
    );
  }
}
