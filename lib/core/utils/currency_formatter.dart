import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }
}