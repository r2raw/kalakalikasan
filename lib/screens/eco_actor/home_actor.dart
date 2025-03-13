import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/widgets/actors/carbon_save_card.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav.dart';
import 'package:kalakalikasan/widgets/actors/recycle_tips_slides.dart';
import 'package:kalakalikasan/widgets/actors/transaction_list.dart';

class HomeActor extends ConsumerWidget {
  const HomeActor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
              top: -400,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
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
                height: 400,
              )),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 100),
              decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 233, 233, 233),
                  ),
              child: Column(
                children: const [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DashboardNav(),
                        ),
                        RecycleTipsSlides(),
                        // TransactionList(transactions: transactionHistory)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const CarbonSaveCard(),
        ],
      ),
    );
  }
}
