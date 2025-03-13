import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/register_step_provider.dart';
import 'package:kalakalikasan/provider/registration_form_provider.dart';
import 'package:kalakalikasan/widgets/registration/step_one.dart';
import 'package:kalakalikasan/widgets/registration/step_three.dart';
import 'package:kalakalikasan/widgets/registration/step_two.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final stepCounter = ref.watch(registerStepProvider);
    final isStepOneValid =
        ref.read(registrationFormProvider.notifier).isStepOneValid();
    final isStepTwoValid =
        ref.read(registrationFormProvider.notifier).isStepTwoValid();
    Widget content = StepOne();
    if (stepCounter == 2) {
      content = StepTwo();
    }

    if (stepCounter == 3) {
      content = StepThree();
    }
    double w = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: w,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                      onPressed: () {
                        ref.read(registerStepProvider.notifier).goToStep(1);
                      },
                      icon: stepCounter == 1
                          ? Icon(Icons.circle)
                          : Icon(Icons.circle_outlined),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                      onPressed: isStepOneValid
                          ? () {
                              ref
                                  .read(registerStepProvider.notifier)
                                  .goToStep(2);
                            }
                          : () {},
                      icon: stepCounter == 2
                          ? Icon(Icons.circle)
                          : Icon(Icons.circle_outlined),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                      onPressed: isStepTwoValid ? () {
                        ref.read(registerStepProvider.notifier).goToStep(3);
                      } : (){},
                      icon: stepCounter == 3
                          ? Icon(Icons.circle)
                          : Icon(Icons.circle_outlined),
                    ),
                  ],
                ),
                content
              ],
            )),
      ),
    );
  }
}
