import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/scan_qr.dart';
import 'package:kalakalikasan/screens/eco_actor/home_actor.dart';
import 'package:kalakalikasan/screens/my_shop_screen.dart';
import 'package:kalakalikasan/screens/notification.dart';
import 'package:kalakalikasan/screens/user_drawer.dart';
import 'package:kalakalikasan/widgets/floating_nav.dart';
import 'package:kalakalikasan/screens/eco_actor/community_updates.dart';

class EcoActors extends ConsumerStatefulWidget {
  const EcoActors({super.key});
  @override
  ConsumerState<EcoActors> createState() {
    // TODO: implement createState
    return _EcoActorsState();
  }
}

class _EcoActorsState extends ConsumerState<EcoActors> {

  @override
  Widget build(BuildContext context) {

    final selectedScreenIndex = ref.watch(screenProvider); 
    final userLastname = ref.watch(currentUserProvider)[CurrentUser.lastName].toString().toUpperCase();
    final userFirstname = ref.watch(currentUserProvider)[CurrentUser.firstName].toString().toUpperCase();
    final fullName = '$userFirstname $userLastname';
    BoxDecoration bg = BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44 )
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          );
    double h = MediaQuery.of(context).size.height;
    Widget appBarTitle = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx)=> UserDrawer()));},
      child:  Row(
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
              Text(fullName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );

    Widget content = HomeActor();
    // TODO: implement build
    // if (_selectedTabIndex == 1) {
    //   appBarTitle = Text('Dashboard',
    //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
    // }
     if (selectedScreenIndex == 2) {
      content = MyShopScreen();
      bg = BoxDecoration(
            color: Color.fromARGB(255, 233, 233, 233)
          );
      appBarTitle = Text('My Shop',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
    }
    if (selectedScreenIndex == 3) {
      content = CommunityUpdates();
      bg = BoxDecoration(
            color: Color.fromARGB(255, 233, 233, 233)
          );
      appBarTitle = Text('Community Updates & Guides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: appBarTitle,
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
                Color.fromARGB(255, 32, 77, 44 )
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        height: h,
        padding:  EdgeInsets.fromLTRB(0, selectedScreenIndex == 0 ? 48 : 0, 0, 0),
        width: double.infinity,
        decoration: bg,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: content,),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FloatingNav(),
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
