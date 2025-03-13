import 'dart:math';

String generateRandomCode() {
  Random random = Random();
  int code = 100000 + random.nextInt(900000); // Ensures 6-digit number
  return code.toString();
}

String generateTransactionID() {
  // Get the current year as a prefix
  String year = DateTime.now().year.toString();

  // Generate a random 7-digit number
  int randomNum = Random().nextInt(9000000) + 1000000; // Ensures a 7-digit number

  // Combine to create the transaction ID
  return '$year$randomNum';
}
