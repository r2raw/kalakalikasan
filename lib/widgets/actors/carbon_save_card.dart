import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/points_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:http/http.dart' as http;

class CarbonSaveCard extends ConsumerStatefulWidget {
  const CarbonSaveCard({super.key});
  @override
  ConsumerState<CarbonSaveCard> createState() {
    // TODO: implement createState
    return _CarbonSaveCard();
  }
}

class _CarbonSaveCard extends ConsumerState<CarbonSaveCard> {
  int grams = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPoints();
    _loadGrams();
  }

  void _loadPoints() async {
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'user-points/$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        ref.read(pointsProvider.notifier).updatePoints(decoded['points']);
      }
    } catch (e) {
      print(e);
    }
  }

  void _loadGrams ()async{
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'total-collected/$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          grams = decoded['totalGrams'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    int currentPoints = ref.watch(pointsProvider);
    // TODO: implement build
    return Positioned(
      top: -100,
      left: 20,
      right: 20,
      child: SizedBox(
        height: 200,
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Expanded(
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(grams.toString(),
                          style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold, fontSize: 30)),
                              SizedBox(height: 12,),
                              Text('Total waste submitted (Grams)', style: Theme.of(context).textTheme.headlineSmall,),
                      
                    ],
                                   ),
                 ),
                Container(
                  width: 2,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 201, 200, 200)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/token-img.png',
                              width: 20,
                              height: 20,
                            ),
                            Text(
                              currentPoints.toString(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            )
                          ]),
                       Text('Eco-Coins', style: Theme.of(context).textTheme.headlineSmall,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
