import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/actors/carbon_save_card.dart';
import 'package:kalakalikasan/widgets/actors/dashboard_nav.dart';
import 'package:kalakalikasan/widgets/actors/recycle_tips_slides.dart';

class HomeActor extends StatelessWidget {
  const HomeActor({super.key});
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Stack(
        
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 100),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
              child: const Column(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          DashboardNav(),
                          RecycleTipsSlides(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CarbonSaveCard(),
        ],
      ),
    );
  }
}
