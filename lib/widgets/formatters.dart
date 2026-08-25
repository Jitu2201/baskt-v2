import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.simpleCurrency(locale: 'en_US');

String formatPrice(double price) => _currencyFormat.format(price);
