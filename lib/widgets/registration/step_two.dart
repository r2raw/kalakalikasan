import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/register_step_provider.dart';
import 'package:kalakalikasan/provider/registration_form_provider.dart';

class StepTwo extends ConsumerStatefulWidget {
  const StepTwo({super.key});

  @override
  ConsumerState<StepTwo> createState() {
    // TODO: implement createState
    return _StepTwo();
  }
}

class _StepTwo extends ConsumerState<StepTwo> {
  final _formKey = GlobalKey<FormState>();
  String street = '';
  String barangay = '';
  String city = '';
  String province = '';

  @override
  void initState() {
    super.initState();
    final regForm = ref.read(registrationFormProvider);
    street = regForm[RegInput.street]!;
    barangay = regForm[RegInput.barangay]!;
    city = regForm[RegInput.city]!;
    province = regForm[RegInput.province]!;
  }

  void _onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(registrationFormProvider.notifier).updateRegForm(RegInput.street, street);
      ref.read(registerStepProvider.notifier).nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Setup your',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
            Text(
              'address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                color: Color.fromARGB(255, 33, 77, 44),
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: street,
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required!';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    street = value!;
                  });
                },
                decoration: InputDecoration(
                  label: Row(
                    children: const [
                      Text(
                        'House No. & Street Address',
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 77, 44),
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 236, 81, 81),
                        ),
                      )
                    ],
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 33, 77, 44),
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: barangay,
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Barangay',
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 77, 44),
                    ),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 33, 77, 44),
                      width: 2,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                      width: 2,
                    ),
                  ),
                ),
                enabled: false,
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: city,
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
                decoration: InputDecoration(
                  label: Text(
                    'City/Municipality',
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 77, 44),
                    ),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 33, 77, 44),
                      width: 2,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                      width: 2,
                    ),
                  ),
                ),
                enabled: false,
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: province,
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
                decoration: InputDecoration(
                  label: Text(
                    'Province',
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 77, 44),
                    ),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 33, 77, 44),
                      width: 2,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                      width: 2,
                    ),
                  ),
                ),
                enabled: false,
              )
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 38, 167, 72)),
              onPressed: () {
                ref.read(registerStepProvider.notifier).prevStep();
              },
              child: Text(
                '<< Previous',
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 38, 167, 72)),
              onPressed: _onSaveForm,
              child: Text(
                'Next >>',
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
