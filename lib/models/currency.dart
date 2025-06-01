class Currency {
  final String code;
  final String name;
  final double rate;

  Currency({required this.code, required this.name, required this.rate});

  factory Currency.fromJson(Map<String, dynamic> json, String code) {
    return Currency(
      code: code,
      name: _getCurrencyName(code),
      rate: json[code].toDouble(),
    );
  }

  static String _getCurrencyName(String code) {
    switch (code) {
      case 'USD':
        return 'Dólar Americano';
      case 'EUR':
        return 'Euro';
      case 'BRL':
        return 'Real Brasileiro';
      default:
        return code;
    }
  }
}
