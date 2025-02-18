import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.goToStep});
  final void Function(int step) goToStep;
  @override
  State<ResetPassword> createState() {
    return _ResetPassword();
  }
}

class _ResetPassword extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.fingerprint,
          size: 60,
          color: Color.fromARGB(255, 32, 77, 44),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Forgot password?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 32, 77, 44),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'No worries, we will send you reset instructions.',
          style: TextStyle(
            color: Color.fromARGB(255, 32, 77, 44),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          child: TextFormField(
            style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
            validator: (value) {
              if (value == null || value.trim().isEmpty || value.length <= 1) {
                return 'This field is a required field!';
              }

              String pattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              RegExp regex = RegExp(pattern);

              if (!regex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text(
                'Email',
                style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
              ),
              fillColor: Color.fromARGB(255, 32, 77, 44),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 38, 167, 72),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 38, 167, 72)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 32, 77, 44),
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            widget.goToStep(2);
          },
          child: const Text(
            'Reset password',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
