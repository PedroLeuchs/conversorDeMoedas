import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_history.dart';

class HistoryService {
  static const String _historyKey = 'conversion_history';

  // Salvar uma nova conversão no histórico
  Future<void> saveConversion(ConversionHistory conversion) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Obter o histórico atual
      List<ConversionHistory> history = await getHistory();

      // Adicionar a nova conversão
      history.add(conversion);

      // Limitar a lista a 20 itens (opcional)
      if (history.length > 20) {
        history = history.sublist(history.length - 20);
      }

      // Converter para JSON e salvar
      List<String> historyJson =
          history.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Erro ao salvar conversão: $e');
    }
  }

  // Obter todo o histórico de conversões
  Future<List<ConversionHistory>> getHistory() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? historyJson = prefs.getStringList(_historyKey);

      if (historyJson == null || historyJson.isEmpty) {
        return [];
      }

      return historyJson
          .map((e) => ConversionHistory.fromJson(jsonDecode(e)))
          .toList()
          .reversed
          .toList(); // Retornar com o mais recente primeiro
    } catch (e) {
      print('Erro ao obter histórico: $e');
      return [];
    }
  }

  // Limpar todo o histórico
  Future<void> clearHistory() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Erro ao limpar histórico: $e');
    }
  }
}
