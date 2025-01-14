import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-YYYY')
        .format(date); //Customize the date as needed
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amount); //Customizethe currency locale and symbol
  }

  static String formatPhoneNumber(String phoneNumber) {
    //Assuming a 10 didgit US-number format (123) {456-789
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }

    //Add more custom number formatting logic for different formats if needed
    return phoneNumber;
  }

  //Not fully tested
  static String internationalFormatPhoneNumber(String phoneNumber) {
    //Remove non digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    //Extract the country code from the digits only
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    //Add the remaining digits with proper fomatting
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode)');

    int i = 0;
    while (i < digitsOnly.length) {
      int grouplength = 2;
      if (i == 0 && countryCode == '+1') {
        grouplength = 3;
      }

      int end = i + grouplength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }
    // Return the formatted phone number
    return formattedNumber.toString();
  }
}
