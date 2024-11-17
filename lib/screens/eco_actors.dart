import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/actors/carbon_save_card.dart';
import 'package:kalakalikasan/widgets/gradient_app_bar.dart';
import 'package:kalakalikasan/widgets/user_app_bar.dart';

class EcoActors extends StatelessWidget {
  const EcoActors({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
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
            const UserAppBar(),
            const Spacer(),
            Column(children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 233, 233, 233)),
                child: const Column(
                  children: [
                    CarbonSaveCard(),
                    Text('Nav'),
                    Text('Recommedaton'),
                  ],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
