import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';

class CurrencyService {
  // Usando a API do AwesomeAPI para taxas de câmbio - não requer API key
  static const String baseUrl =
      'https://economia.awesomeapi.com.br/json/all/USD-BRL,EUR-BRL';

  Future<Map<String, Currency>> fetchExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final Map<String, Currency> currencies = {};

        // Adicionando o Real com taxa 1.0
        currencies['BRL'] = Currency(
          code: 'BRL',
          name: 'Real Brasileiro',
          rate: 1.0,
        );

        // Adicionando Dólar
        if (data.containsKey('USD')) {
          final usdRate = double.parse(data['USD']['bid']);
          currencies['USD'] = Currency(
            code: 'USD',
            name: 'Dólar Americano',
            rate: 1.0 / usdRate, // Invertendo para obter BRL -> USD
          );
        }

        // Adicionando Euro
        if (data.containsKey('EUR')) {
          final eurRate = double.parse(data['EUR']['bid']);
          currencies['EUR'] = Currency(
            code: 'EUR',
            name: 'Euro',
            rate: 1.0 / eurRate, // Invertendo para obter BRL -> EUR
          );
        }

        return currencies;
      } else {
        throw Exception(
            'Falha ao carregar taxas de câmbio: ${response.statusCode}');
      }
    } catch (e) {
      // Tratamento de erro mais específico
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Network is unreachable')) {
        throw Exception(
            'Sem conexão com a internet. Verifique sua rede e tente novamente.');
      } else if (e.toString().contains('403')) {
        throw Exception(
            'Acesso negado pela API. A chave de API pode estar inválida ou expirada.');
      } else if (e.toString().contains('429')) {
        throw Exception(
            'Limite de requisições excedido. Tente novamente mais tarde.');
      } else {
        throw Exception('Erro ao buscar taxas de câmbio: $e');
      }
    }
  }

  double convert(double amount, double fromRate, double toRate) {
    return amount * (toRate / fromRate);
  }
}
