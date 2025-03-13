import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/landing_screen_provider.dart';
import 'package:kalakalikasan/provider/register_step_provider.dart';
import 'package:kalakalikasan/provider/registration_form_provider.dart';
import 'package:kalakalikasan/screens/login.dart';

class StepOne extends ConsumerStatefulWidget {
  const StepOne({super.key});
  @override
  ConsumerState<StepOne> createState() {
    return _StepOne();
  }
}

class _StepOne extends ConsumerState<StepOne> {
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String middleName = '';
  String _selectedGender = '';
  @override
  void initState() {
    super.initState();
    final regForm = ref.read(registrationFormProvider);
    setState(() {
      firstName = regForm[RegInput.firstname]!;
      lastName = regForm[RegInput.lastname]!;
      middleName = regForm[RegInput.middlename]!;
      _dateController.text = regForm[RegInput.birthdate]!;
      _selectedGender = regForm[RegInput.sex]!;
    });
  }
  void _onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ref.read(registrationFormProvider.notifier).updateRegForm(RegInput.firstname, firstName);
      ref.read(registrationFormProvider.notifier).updateRegForm(RegInput.lastname, lastName);
      ref.read(registrationFormProvider.notifier).updateRegForm(RegInput.middlename, middleName);
      ref.read(registrationFormProvider.notifier).updateRegForm(RegInput.birthdate, _dateController.text);
      ref.read(registrationFormProvider.notifier).updateRegForm(RegInput.sex, _selectedGender);
      ref.read(registerStepProvider.notifier).nextStep();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  final DateTime past18Years = DateTime(
      DateTime.now().year - 13, DateTime.now().month, DateTime.now().day);

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: past18Years,
      firstDate: DateTime(1900),
      lastDate: past18Years,
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Create an',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
            Text(
              'account',
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              initialValue: firstName,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required!';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  firstName = value!;
                });
              },
              style: TextStyle(
                color: Color.fromARGB(255, 33, 77, 44),
              ),
              decoration: InputDecoration(
                label: Row(
                  children: const [
                    Text(
                      'First name',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      ),
                    ),
                    Text(' *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 236, 81, 81),
                        ))
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
              initialValue: middleName,
              onSaved: (value) {
                setState(() {
                  middleName = value!;
                });
              },
              style: TextStyle(
                color: Color.fromARGB(255, 33, 77, 44),
              ),
              decoration: InputDecoration(
                label: Text(
                  'Middle name',
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
            TextFormField( //Lastname
              initialValue: lastName,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required!';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  lastName = value!;
                });
              },
              style: TextStyle(
                color: Color.fromARGB(255, 33, 77, 44),
              ),
              decoration: InputDecoration(
                label: Row(
                  children: const [
                    Text(
                      'Last name',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      ),
                    ),
                    Text(' *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 236, 81, 81),
                        ))
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
              onTap: _selectDate,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required!';
                }

                if (DateTime.tryParse(value) == null) {
                  return 'Please enter a valid birthdate';
                }

                if (DateTime.parse(value).isAfter(past18Years)) {
                  return 'Must be 13 years old or older';
                }
                return null;
              },
              onSaved: (value) {
                final enteredDate = DateTime.parse(value!);
                setState(() {
                  _dateController.text =
                      "${enteredDate.toLocal()}".split(' ')[0];
                });
              },
              style: TextStyle(
                color: Color.fromARGB(255, 33, 77, 44),
              ),
              controller: _dateController,
              decoration: InputDecoration(
                label: Row(
                  children: const [
                    Text(
                      'Birthdate (yyyy-MM-dd)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 77, 44),
                      ),
                    ),
                    Text(' *',
                        style: TextStyle(
                          color: Color.fromARGB(255, 236, 81, 81),
                        ))
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
            SizedBox(height: 12),
            Row(
              children: [
                Text('Sex:'),
                Text(' *',
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 81, 81),
                    )),
                Expanded(
                  child: RadioListTile(
                    activeColor: Color.fromARGB(255, 33, 77, 44),
                    fillColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 38, 167, 72)),
                    value: 'male',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    title: Text('Male'),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: RadioListTile(
                      activeColor: Color.fromARGB(255, 33, 77, 44),
                      fillColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 38, 167, 72)),
                      value: 'female',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                      title: Text('Female'),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    overlayColor: Color.fromARGB(255, 38, 167, 72)),
                onPressed: _onSaveForm,
                child: Text('Next >>',
                    style: TextStyle(
                      color: Color.fromARGB(255, 33, 77, 44),
                    ))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: TextButton(
            onPressed: () {
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (ctx) => Login()));
               ref.read(landingScreenProvider.notifier).swapScreen(0);
            },
            style: TextButton.styleFrom(
                overlayColor: Color.fromARGB(255, 38, 167, 72)),
            child: Text('Sign in your account',
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 77, 44),
                )),
          ),
        )
      ],
    );
  }
}
