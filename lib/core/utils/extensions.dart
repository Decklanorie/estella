import 'package:intl/intl.dart';


extension ExtensionsOnMap on Map?{
  Map<String, dynamic> get toStringDynamic => this==null?{}: this!.map((key, value) => MapEntry(key.toString(), value));
}


extension ExtensionsOnDouble on double?{
  String get toShort => this==null?"0.00": _formatShortCurrency(this!);
  String get toMedium => this==null?"0.00": _formatMediusCurrency(this!);
}

String _formatShortCurrency(double value) {
  if (value >= 1e6) {
    return '${(value / 1e6).toStringAsFixed(1)}M'; // Million
  } else if (value >= 1e3) {
    return '${(value / 1e3).toStringAsFixed(1)}K'; // Thousand
  } else {
    return value.toStringAsFixed(2); // Regular format
  }
}
String _formatMediusCurrency(double value) {
  if (value >= 1e6) {
    return '${(value / 1e6).toStringAsFixed(1)}M'; // Million
  } else if (value >= 1e3) {
    return _formatAmount(value); // Thousand
  } else {
    return value.toStringAsFixed(2); // Regular format
  }
}

String _formatAmount(double amount) {
  final formatter =
  NumberFormat.currency(locale: 'en_NG', symbol: '', decimalDigits: 2);
  String formattedAmount = formatter.format(amount);
  return formattedAmount;
}