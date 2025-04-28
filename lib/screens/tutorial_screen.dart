import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/landing_screen_provider.dart';
import 'package:kalakalikasan/provider/tutorial_screen_provider.dart';
import 'package:kalakalikasan/widgets/tutorial/first_tutorial.dart';
import 'package:kalakalikasan/widgets/tutorial/fourth_tutorial.dart';
import 'package:kalakalikasan/widgets/tutorial/second_tutorial.dart';
import 'package:kalakalikasan/widgets/tutorial/third_tutorial.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() {
    return _TutorialScreenState();
  }
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  void _nextTutorialStep() {
    ref.read(tutorialScreenProvider.notifier).nextScreen();
  }

  void _goToLogin(){ 
    ref.read(tutorialScreenProvider.notifier).swapScreen(0);
    ref.read(landingScreenProvider.notifier).swapScreen(0);
  }

  @override
  Widget build(BuildContext context) {
    final currentTuts = ref.watch(tutorialScreenProvider);
    Widget currTuts = FirstTutorial();

    if (currentTuts == 1) {
      currTuts = SecondTutorial();
    }

    if (currentTuts == 2) {
      currTuts = ThirdTutorial();
    }

    if (currentTuts == 3) {
      currTuts = FourthTutorial();
    }
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 140, 253, 119),
              Color.fromARGB(255, 15, 81, 60)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: _goToLogin,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ))
              ],
            ),
            currTuts,
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  IconButton(
                      onPressed: () {
                        ref.read(tutorialScreenProvider.notifier).swapScreen(i);
                      },
                      icon: currentTuts == i
                          ? Icon(
                              Icons.circle,
                            )
                          : Icon(Icons.circle_outlined))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (currentTuts != 3)
                      TextButton(
                        onPressed: _nextTutorialStep,
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    if (currentTuts == 3)
                      TextButton(
                        onPressed:_goToLogin,
                        child: Text(
                          'Get Started!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
