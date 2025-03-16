import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/otp_provider.dart';
import 'package:kalakalikasan/provider/registration_form_provider.dart';
import 'package:kalakalikasan/widgets/error_single.dart';

class RegistrationOtp extends ConsumerStatefulWidget {
  const RegistrationOtp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RegistrationOtp();
  }
}

class _RegistrationOtp extends ConsumerState<RegistrationOtp> {
  String? _error;
  final List<String> _otp = List.filled(6, "");
  void _updateOtp(int index, String value) {
    setState(() {
      _otp[index] = value;
    });
  }

  void _submitOtp() {
    String otpCode = _otp.join();
    final sentOtp = ref.read(otpProvider);

    if (otpCode != sentOtp) {
      setState(() {
        _error = 'Invalid otp';
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _error = null;
        });
      });
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final mobileNum = ref.read(registrationFormProvider)[RegInput.mobileNum];
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mobile_friendly,
                size: 60,
                color: Color.fromARGB(255, 32, 77, 44),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Verify phone number',
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
                'We sent a code to $mobileNum',
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
                        style:
                            TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ErrorSingle(errorMessage: _error),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 32, 77, 44),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _submitOtp,
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
