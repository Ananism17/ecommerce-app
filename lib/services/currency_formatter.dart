import 'package:intl/intl.dart';

String formatCurrency(double value) {
  var currencyFormat = NumberFormat.currency(
    symbol: '৳', // Set the currency symbol to an empty string
    decimalDigits: 2, // Number of decimal places
    customPattern: '##,##,##,###.##', // Your custom pattern
  );

  return currencyFormat.format(value);
}