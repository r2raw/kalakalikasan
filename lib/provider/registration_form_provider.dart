import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RegInput {
  firstname,
  lastname,
  middlename,
  birthdate,
  sex,
  street,
  barangay,
  city,
  province,
  zip,
  username,
  email,
  mobileNum,
  password,
  confirmPassword,
}

class RegistrationFormNotifier extends StateNotifier<Map<RegInput, String>> {
  RegistrationFormNotifier()
      : super({
          RegInput.firstname: '',
          RegInput.lastname: '',
          RegInput.middlename: '',
          RegInput.birthdate: '',
          RegInput.sex: 'male',
          RegInput.street: '',
          RegInput.barangay: 'Batasan Hills',
          RegInput.city: 'Quezon City',
          RegInput.province: 'Metro-Manila',
          RegInput.zip: '1126',
          RegInput.username: '',
          RegInput.email: '',
          RegInput.mobileNum: '',
          RegInput.password: '',
          RegInput.confirmPassword: '',
        });

  // Add methods to update the state as needed
  void updateRegForm(RegInput keyName, String inputValue) {
    state = {...state, keyName: inputValue};
  }

  void resetForm() {
    state = {
      RegInput.firstname: '',
      RegInput.lastname: '',
      RegInput.middlename: '',
      RegInput.birthdate: '',
      RegInput.sex: 'male',
      RegInput.street: '',
      RegInput.barangay: 'Batasan Hills',
      RegInput.city: 'Quezon City',
      RegInput.province: 'Metro-Manila',
      RegInput.zip: '1126',
      RegInput.username: '',
      RegInput.email: '',
      RegInput.mobileNum: '',
      RegInput.password: '',
      RegInput.confirmPassword: '',
    };
  }

  bool isStepOneValid() {
    final requiredFields = [
      RegInput.firstname,
      RegInput.lastname,
      RegInput.birthdate,
      RegInput.sex,
    ];

    for (var field in requiredFields) {
      if (state[field]?.isEmpty ?? true) {
        return false;
      }
    }
    return true;
  }

  bool isStepTwoValid() {
    final requiredFields = [
      RegInput.street,
      RegInput.barangay,
      RegInput.city,
      RegInput.province,
      RegInput.zip,
    ];

    for (var field in requiredFields) {
      if (state[field]?.isEmpty ?? true) {
        return false;
      }
    }
    return true;
  }
}

final registrationFormProvider =
    StateNotifierProvider<RegistrationFormNotifier, Map<RegInput, String>>(
        (ref) {
  return RegistrationFormNotifier();
});
