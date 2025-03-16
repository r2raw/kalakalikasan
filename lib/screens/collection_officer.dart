import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/main.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/notif_provider.dart';
import 'package:kalakalikasan/provider/rates_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/home_officer.dart';
import 'package:kalakalikasan/screens/collection_officer/scan_qr.dart';
import 'package:kalakalikasan/screens/eco_actor/community_updates.dart';
import 'package:kalakalikasan/screens/notification.dart';
import 'package:kalakalikasan/screens/user_drawer.dart';
import 'package:kalakalikasan/widgets/officer_floating_nav.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/util/text_casing.dart';

class CollectionOfficerScreen extends ConsumerStatefulWidget {
  const CollectionOfficerScreen({super.key});

  @override
  ConsumerState<CollectionOfficerScreen> createState() {
    return _CollectionOfficerState();
  }
}

class _CollectionOfficerState extends ConsumerState<CollectionOfficerScreen>
    with RouteAware {
  Map<Notif, dynamic> notifs = {Notif.unread: [], Notif.read: []};
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

  @override
  void initState() {
    super.initState();
    _loadRate();
    _loadNotif();
  }

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

  void _loadRate() async {
    try {
      final url = Uri.https('kalakalikasan-server.onrender.com', 'rates');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final petBottle = decoded['pet_bottle'];
        final incanBottle = decoded['incan_bottle'];

        final Map<Rates, int> returnedRates = {
          Rates.petPoints: petBottle['points_value'],
          Rates.petCoins: petBottle['coins_value'],
          Rates.canCoins: incanBottle['coins_value'],
          Rates.canPoints: incanBottle['points_value']
        };

        ref.read(ratesProvider.notifier).saveRates(returnedRates);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong')));
    }
  }

  void _tabSelect(int index) {
    ref.read(screenProvider.notifier).swapScreen(index);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(notifProvider);
    final userInfo = ref.watch(currentUserProvider);
    final fullName = '${userInfo[CurrentUser.firstName]} ${userInfo[CurrentUser.lastName]}';
    final unreadNotifs = notifs[Notif.unread];
    int _selectedTabIndex = ref.watch(screenProvider);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Widget content = SingleChildScrollView(child: HomeOfficer());

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
              Text(toTitleCase(fullName),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );

    if (_selectedTabIndex == 1) {
      content = ScanQr();

      appBarTitle = Text('Scanner',
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 72, 114, 50),
                  Color.fromARGB(255, 32, 77, 44)
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              color: Theme.of(context).canvasColor),
        ),
      ),
      body: Container(
        height: h,
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
            // color: Color.fromARGB(255, 233, 233, 233),
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
    );
  }
}
