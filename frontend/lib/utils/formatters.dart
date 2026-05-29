import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String formatBRL(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  static String formatUSD(double value) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: 'US\$');
    return formatter.format(value);
  }

  static String formatEUR(double value) {
    final formatter = NumberFormat.currency(locale: 'eu', symbol: '€');
    return formatter.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM', 'pt_BR').format(date);
  }
}
