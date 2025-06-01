import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/currency_provider.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'BRL';
  String _toCurrency = 'USD';
  double _result = 0.0;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'pt_BR');

  @override
  void initState() {
    super.initState();
    // Carregar taxas de câmbio quando a tela for iniciada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrencyProvider>(context, listen: false).loadExchangeRates();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    if (_amountController.text.isEmpty) return;

    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

    if (amount <= 0) return;

    final result = provider.convert(amount, _fromCurrency, _toCurrency);

    setState(() {
      _result = result;
    });

    // Salvar a conversão no histórico
    provider.saveConversion(_fromCurrency, _toCurrency, amount, result);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Não foi possível carregar as taxas de câmbio. Verifique sua conexão com a internet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => provider.loadExchangeRates(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        final currencies = provider.currencies;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de valor
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
              ),
              const SizedBox(height: 16),

              // Seleção de moedas
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'De',
                        border: OutlineInputBorder(),
                      ),
                      value: _fromCurrency,
                      items: currencies.keys.map((code) {
                        return DropdownMenuItem<String>(
                          value: code,
                          child: Text('$code - ${currencies[code]!.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _fromCurrency = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      setState(() {
                        final temp = _fromCurrency;
                        _fromCurrency = _toCurrency;
                        _toCurrency = temp;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Para',
                        border: OutlineInputBorder(),
                      ),
                      value: _toCurrency,
                      items: currencies.keys.map((code) {
                        return DropdownMenuItem<String>(
                          value: code,
                          child: Text('$code - ${currencies[code]!.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _toCurrency = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botão de conversão
              ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Converter', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),

              // Resultado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Resultado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currencyFormat.format(_result),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_toCurrency - ${currencies[_toCurrency]?.name ?? ""}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Taxa de câmbio atual
              if (currencies.isNotEmpty &&
                  currencies.containsKey(_fromCurrency) &&
                  currencies.containsKey(_toCurrency))
                Column(
                  children: [
                    Text(
                      'Taxa de câmbio: 1 $_fromCurrency = ${(currencies[_toCurrency]!.rate / currencies[_fromCurrency]!.rate).toStringAsFixed(4)} $_toCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        provider.loadExchangeRates();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Atualizando taxas de câmbio...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Atualizar taxas'),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
