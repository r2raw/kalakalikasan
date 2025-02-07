import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/collection_officer/home_officer.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';
import 'package:kalakalikasan/screens/collection_officer/scan_qr.dart';
import 'package:kalakalikasan/screens/eco_actor/collection_schedules.dart';
import 'package:kalakalikasan/screens/eco_actor/community_updates.dart';
import 'package:kalakalikasan/screens/login.dart';
import 'package:kalakalikasan/screens/notification.dart';
import 'package:kalakalikasan/screens/user_drawer.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav_item.dart';
import 'package:kalakalikasan/widgets/officer_floating_nav.dart';

class CollectionOfficerScreen extends StatefulWidget {
  const CollectionOfficerScreen({super.key});

  @override
  State<CollectionOfficerScreen> createState() {
    // TODO: implement createState
    return _CollectionOfficerState();
  }
}

class _CollectionOfficerState extends State<CollectionOfficerScreen>{
  
  int _selectedTabIndex = 0;

  void _tabSelect(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Widget content = HomeOfficer();

    Widget appBarTitle = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => UserDrawer(),
          ),
        );
      },
      child: const Row(
        children: [
          Icon(
            Icons.person,
            size: 40,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,',
                style: TextStyle(fontSize: 16),
              ),
              Text('Juan Dela Cruz',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );

    if (_selectedTabIndex == 1) {
      content = ScanQr();
      
      appBarTitle = Text('Qr Scan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
      // Navigator.push(context, MaterialPageRoute(builder: (ctx)=> QrResultScreen()));
    }

    
    if (_selectedTabIndex == 2) {
      content = CommunityUpdates();
      appBarTitle = Text('Community Updates & Guides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => NotificationScreen()));
              },
              icon: const Icon(
                Icons.notifications,
                size: 30,
              ))
        ],
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
      ),
      body: Container(
        height: h,
        padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
        width: w,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     // Color.fromARGB(255, 141, 253, 120),
          //     // Color.fromARGB(255, 0, 131, 89)
          //     Color.fromARGB(255, 72, 114, 50),
          //     Color.fromARGB(255, 32, 77, 44)
          //   ],
          //   begin: Alignment.centerRight,
          //   end: Alignment.centerLeft,
          // ),
          color: Color.fromARGB(255, 233, 233, 233)
        ),
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    content,
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: OfficerFloatingNav(
                          onTabSelect: _tabSelect,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}