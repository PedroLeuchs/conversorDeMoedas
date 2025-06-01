import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/currency_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR');

    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        final history = provider.history;

        if (history.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma conversão realizada ainda.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Limpar histórico'),
                          content: const Text(
                              'Tem certeza que deseja limpar todo o histórico de conversões?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                provider.clearHistory();
                                Navigator.pop(context);
                              },
                              child: const Text('Limpar'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Limpar histórico'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            '${currencyFormat.format(item.amount)} ${item.fromCurrency}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward, size: 16),
                          ),
                          Text(
                            '${currencyFormat.format(item.result)} ${item.toCurrency}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(item.formattedDate),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
