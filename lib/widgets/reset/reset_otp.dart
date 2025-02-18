import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetOtp extends StatefulWidget {
  const ResetOtp({super.key, required this.goToStep});
  final void Function(int step) goToStep;

  @override
  State<ResetOtp> createState() {
    return _ResetOtp();
  }
}

class _ResetOtp extends State<ResetOtp> {
   final List<String> _otp = List.filled(6, "");

   void _updateOtp(int index, String value) {
    setState(() {
      _otp[index] = value;
    });
  }

  void _submitOtp() {
    String otpCode = _otp.join();
    widget.goToStep(3);
    print("Entered OTP: $otpCode"); // Replace with your logic
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mail_outline_sharp,
          size: 60,
          color: Color.fromARGB(255, 32, 77, 44),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Reset Password',
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
          textAlign: TextAlign.center,
          'We sent a code to xxxxx@gmail.com',
          style: TextStyle(
            color: Color.fromARGB(255, 32, 77, 44),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Form(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                height: 64,
                width: 40,
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 1) {
                      _updateOtp(index, value);
                      if (index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    }
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 38, 167, 72),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 38, 167, 72),
                      ),
                    ),
                  ),
                ),
              );
            }),
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
          onPressed: _submitOtp,
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
