import 'package:flutter/material.dart';

class SetNewPass extends StatefulWidget {
  const SetNewPass({super.key});
  @override
  State<SetNewPass> createState() {
    return _SetNewPass();
  }
}

class _SetNewPass extends State<SetNewPass> {
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
          'Set new password',
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
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }

                  if (value.length < 8) {
                    return 'Password should have 8 characters minimum';
                  }
                  final passwordRegex = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                  if (!passwordRegex.hasMatch(value)) {
                    return 'Password must include:\n1 uppercase letter, 1 number, and 1 symbol';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text(
                    'New password',
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 38, 167, 72)),
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length <= 1) {
                    return 'This field is a required field!';
                  }

                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(pattern);

                  if (!regex.hasMatch(value)) {
                    return 'Enter a valid password address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text(
                    'Confirm password',
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 38, 167, 72)),
                  ),
                ),
              )
            ],
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
          onPressed: () {},
          child: const Text(
            'Reset password',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
