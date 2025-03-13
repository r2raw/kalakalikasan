import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/points_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/widgets/under_construction.dart';

class PointExchangeScreen extends ConsumerWidget {
  const PointExchangeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref
        .read(currentUserProvider)[CurrentUser.firstName]
        .toString()
        .toUpperCase();
    final lastName = ref
        .read(currentUserProvider)[CurrentUser.lastName]
        .toString()
        .toUpperCase();

    final points = ref.read(pointsProvider);
    final fullName = textTruncate('$firstName $lastName', 17);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
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
        title: Text('My QR'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       // Color.fromARGB(255, 141, 253, 120),
        //       // Color.fromARGB(255, 0, 131, 89)
        //       Color.fromARGB(255, 72, 114, 50),
        //       Color.fromARGB(255, 32, 77, 44)
        //     ],
        //     begin: Alignment.centerRight,
        //     end: Alignment.centerLeft,
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://kalakalikasan-server.onrender.com/userQr/${ref.read(currentUserProvider)[CurrentUser.id]}.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      toTitleCase(fullName),
                      style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/token-img.png',
                              width: 30,
                              height: 30,
                            ),
                            Text(
                              points.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Eco-Coins',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Card(
            //   clipBehavior: Clip.antiAlias,
            //   child: Container(
            //       width: double.infinity,
            //       height: 800,
            //       decoration: BoxDecoration(color: Colors.white),
            //       child: UnderConstruction()),
            // ),
          ],
        ),
      ),
    );
  }
}
