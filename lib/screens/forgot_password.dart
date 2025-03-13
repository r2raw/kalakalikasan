import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/landing_screen_provider.dart';
import 'package:kalakalikasan/screens/login.dart';
import 'package:kalakalikasan/widgets/reset/reset_otp.dart';
import 'package:kalakalikasan/widgets/reset/reset_password.dart';
import 'package:kalakalikasan/widgets/reset/set_new_pass.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() {
    return _ForgotPasswordScreen();
  }
}

class _ForgotPasswordScreen extends ConsumerState<ForgotPasswordScreen> {
  String? otp;

  int resetPasswordStep = 1;
  void _backToLogin() {
    // Navigator.push(context, MaterialPageRoute(builder: (ctx) => Login()));
    ref.read(landingScreenProvider.notifier).swapScreen(0);
  }

  void _goToStep(int step) {
    setState(() {
      resetPasswordStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ResetPassword(goToStep: _goToStep);

    if (resetPasswordStep == 2) {
      content = ResetOtp(
        goToStep: _goToStep,
      );
    }

    if (resetPasswordStep == 3) {
      content = SetNewPass();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 700,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: content,
              ),
              TextButton.icon(
                onPressed: _backToLogin,
                style: TextButton.styleFrom(
                    overlayColor: Color.fromARGB(255, 38, 167, 72),
                    foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                label: Text('Back to login'),
                icon: Icon(Icons.arrow_back),
              )
            ],
          ),
        ),
      ),
    );
  }
}
