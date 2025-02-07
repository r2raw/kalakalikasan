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
    
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Stack(
        
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 100),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
              child:  Column(
                children: const [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        DashboardNav(),
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

