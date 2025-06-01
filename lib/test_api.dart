import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Usando a API pública de ExchangeRate-API
  const String apiKey = 'bc01f6c741ea04b5e2ba3b3b';
  const String baseUrl =
      'https://v6.exchangerate-api.com/v6/$apiKey/latest/BRL';

  try {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Status: ${data['result']}');

      final rates = data['conversion_rates'] as Map<String, dynamic>;
      print('USD: ${rates['USD']}');
      print('EUR: ${rates['EUR']}');
    } else {
      print('Falha ao carregar taxas de câmbio: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Erro ao buscar taxas de câmbio: $e');
  }
}
