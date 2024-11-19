import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_actor/home_actor.dart';
import 'package:kalakalikasan/screens/notification.dart';
import 'package:kalakalikasan/widgets/floating_nav.dart';
import 'package:kalakalikasan/screens/eco_actor/community_updates.dart';
import 'package:kalakalikasan/widgets/user_app_bar.dart';

class EcoActors extends StatefulWidget {
  const EcoActors({super.key});
  @override
  State<EcoActors> createState() {
    // TODO: implement createState
    return _EcoActorsState();
  }
}

class _EcoActorsState extends State<EcoActors> {
  int _selectedTabIndex = 0;

  void _tabSelect(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    Widget appBarTitle = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
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

    Widget content = HomeActor();
    // TODO: implement build
    if (_selectedTabIndex == 1) {
      appBarTitle = Text('Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    }
    if (_selectedTabIndex == 2) {
      content = CommunityUpdates();
      appBarTitle = Text('Community Updates & Guides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => NotificationScreen()));
              },
              icon: const Icon(
                Icons.notifications,
                size: 40,
              ))
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 141, 253, 120),
                Color.fromARGB(255, 0, 131, 89)
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
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 141, 253, 120),
              Color.fromARGB(255, 0, 131, 89)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
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
                    child: FloatingNav(
                      onTabSelect: _tabSelect,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
