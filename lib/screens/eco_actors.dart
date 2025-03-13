import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/main.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/notif_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/home_actor.dart';
import 'package:kalakalikasan/screens/eco_actor/qr_actor.dart';
import 'package:kalakalikasan/screens/my_shop_screen.dart';
import 'package:kalakalikasan/screens/notification.dart';
import 'package:kalakalikasan/screens/user_drawer.dart';
import 'package:kalakalikasan/widgets/floating_nav.dart';
import 'package:kalakalikasan/screens/eco_actor/community_updates.dart';
import 'package:http/http.dart' as http;

class EcoActors extends ConsumerStatefulWidget {
  const EcoActors({super.key});
  @override
  ConsumerState<EcoActors> createState() {
    // TODO: implement createState
    return _EcoActorsState();
  }
}

class _EcoActorsState extends ConsumerState<EcoActors> with RouteAware {
  Map<Notif, dynamic> notifs = {Notif.unread: [], Notif.read: []};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNotif();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('dependencies changingaa');
    _loadNotif();
    // Ensure the current route is a PageRoute before subscribing
    final ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute<dynamic>) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    print('disposing');
    routeObserver.unsubscribe(this); // Unsubscribe when widget is removed
    super.dispose();
  }

  // @override
  // void didPopNext() {
  //   final routeName = ModalRoute.of(context)?.settings.name;
  //   print("🔄 didPopNext() TRIGGERED! Current Route: $routeName");
  //   _loadNotif();
  // }

  void _loadNotif() async {
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'notifications/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final resNotif = {
          Notif.unread: decoded['notifObj']['unread'],
          Notif.read: decoded['notifObj']['read'],
        };

        ref.read(notifProvider.notifier).saveNotif(resNotif);
        final notifres = ref.read(notifProvider);
        setState(() {
          notifs = notifres;
        });
      }
      print('status: ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(notifProvider);
    final unreadNotifs = notifs[Notif.unread];

    final selectedScreenIndex = ref.watch(screenProvider);

    BoxDecoration bg =  BoxDecoration(
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
          );
    ref.listen<int>(screenProvider, (previous, next) {
      if (previous != next) {
        _loadNotif();
      }
    });

    final userLastname = ref
        .watch(currentUserProvider)[CurrentUser.lastName]
        .toString()
        .toUpperCase();
    final userFirstname = ref
        .watch(currentUserProvider)[CurrentUser.firstName]
        .toString()
        .toUpperCase();
    final fullName = '$userFirstname $userLastname';
    double h = MediaQuery.of(context).size.height;
    Widget appBarTitle = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => UserDrawer()));
      },
      child: Row(
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
      bg = BoxDecoration(color: Color.fromARGB(255, 233, 233, 233));
      appBarTitle = Text('My Shop',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
    }
    if (selectedScreenIndex == 3) {
      content = CommunityUpdates();
      bg = BoxDecoration(color: Color.fromARGB(255, 233, 233, 233));
      appBarTitle = Text('Community Updates & Guides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ));
    }
    if (selectedScreenIndex == 4) {
      content = QrActor();
      // bg = BoxDecoration(color: Color.fromARGB(255, 233, 233, 233));
      appBarTitle = Text('Scan Receipt',
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
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  if (notifs.isNotEmpty && unreadNotifs.length > 0)
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              // borderRadius: BorderRadius.circular(360),
                              shape: BoxShape.circle),
                          child: Text(
                            unreadNotifs.length.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                ],
              ))
        ],
        flexibleSpace: Container(
          decoration:  BoxDecoration(
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
        padding:
            EdgeInsets.fromLTRB(0, selectedScreenIndex == 0 ? 48 : 0, 0, 0),
        width: double.infinity,
        // decoration: bg,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: content,
                  ),
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
