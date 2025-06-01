import 'package:intl/intl.dart';

class ConversionHistory {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final DateTime date;

  ConversionHistory({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.date,
  });

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      amount: json['amount'],
      result: json['result'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'result': result,
      'date': date.toIso8601String(),
    };
  }

  String get formattedDate {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }
}
