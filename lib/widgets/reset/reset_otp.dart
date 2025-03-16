import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/reset_otp_provider.dart';
import 'package:kalakalikasan/widgets/error_single.dart';

class ResetOtp extends ConsumerStatefulWidget {
  const ResetOtp({super.key, required this.goToStep});
  final void Function(int step) goToStep;

  @override
  ConsumerState<ResetOtp> createState() {
    return _ResetOtp();
  }
}

class _ResetOtp extends ConsumerState<ResetOtp> {
  final List<String> _otp = List.filled(6, "");
  String? _error;

  void _updateOtp(int index, String value) {
    setState(() {
      _otp[index] = value;
    });
  }

  void _submitOtp() {
    String otpCode = _otp.join();

    final resetInfo = ref.read(resetProvider);
    if(resetInfo[Reset.otp] != otpCode){
      setState(() {
        _error = 'Invalid otp code';
      });
      Future.delayed(Duration(seconds: 3), (){
        setState(() {
          _error = null;
        });
      });
      return;
    }
    widget.goToStep(3);
    print("Entered OTP: $otpCode"); // Replace with your logic
  }

  @override
  Widget build(BuildContext context) {
    final resetInfo = ref.read(resetProvider);
    final resetEmail = resetInfo[Reset.email];
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
          'We sent a code to $resetEmail',
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
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ErrorSingle(errorMessage: _error),
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
