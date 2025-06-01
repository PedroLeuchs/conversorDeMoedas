import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../models/conversion_history.dart';
import '../services/currency_service.dart';
import '../services/history_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  final HistoryService _historyService = HistoryService();

  Map<String, Currency> _currencies = {};
  bool _isLoading = false;
  String _error = '';
  List<ConversionHistory> _history = [];

  // Getters
  Map<String, Currency> get currencies => _currencies;
  bool get isLoading => _isLoading;
  String get error => _error;
  List<ConversionHistory> get history => _history;
  // Carregar taxas de câmbio
  Future<void> loadExchangeRates() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currencies = await _currencyService.fetchExchangeRates();
      await loadHistory();
    } catch (e) {
      _error = 'Não foi possível carregar as taxas de câmbio. ${e.toString()}';

      // Adicionar moedas com valores padrão se ocorrer um erro
      _currencies = {
        'BRL': Currency(code: 'BRL', name: 'Real Brasileiro', rate: 1.0),
        'USD': Currency(
            code: 'USD',
            name: 'Dólar Americano',
            rate: 0.2), // Valores aproximados
        'EUR': Currency(
            code: 'EUR', name: 'Euro', rate: 0.18), // Valores aproximados
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Converter valor
  double convert(double amount, String fromCurrency, String toCurrency) {
    if (_currencies.isEmpty ||
        !_currencies.containsKey(fromCurrency) ||
        !_currencies.containsKey(toCurrency)) {
      return 0.0;
    }

    final fromRate = _currencies[fromCurrency]!.rate;
    final toRate = _currencies[toCurrency]!.rate;

    return _currencyService.convert(amount, fromRate, toRate);
  }

  // Salvar conversão no histórico
  Future<void> saveConversion(String fromCurrency, String toCurrency,
      double amount, double result) async {
    final conversion = ConversionHistory(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount,
      result: result,
      date: DateTime.now(),
    );

    await _historyService.saveConversion(conversion);
    await loadHistory();
  }

  // Carregar histórico
  Future<void> loadHistory() async {
    _history = await _historyService.getHistory();
    notifyListeners();
  }

  // Limpar histórico
  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    await loadHistory();
  }
}
