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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPoints();
  }

  void _loadPoints() async {
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url = Uri.http(ref.read(urlProvider), 'user-points/$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        ref.read(pointsProvider.notifier).updatePoints(decoded['points']);
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('500g',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 48)),
                    Text(
                      'Saved C02',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 2,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 201, 200, 200)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/token-img.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            currentPoints.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 48),
                          )
                        ]),
                    const Text('Eco Coins'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
