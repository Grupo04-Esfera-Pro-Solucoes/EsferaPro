import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Future<Map<String, dynamic>> getLeadsByDayOfTheWeek(String userId) async {
    final url = Uri.parse('$baseUrl/lead/graph/leadsweek/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar');
    }
  }

  Future<Map<String, dynamic>> getLeadsByDayOfTheMonth(String userId) async {
    final url = Uri.parse('$baseUrl/lead/graph/leadsmonth/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar');
    }
  }

  Future<Map<String, dynamic>> getProposalsByDayOfTheMonth(
      String userId) async {
    final url = Uri.parse('$baseUrl/proposal/graph/proposalsmonth/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar');
    }
  }

  Future<Map<String, dynamic>> getFaturamento(String userId) async {
    final url = Uri.parse('$baseUrl/proposal/faturamento/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar faturamento');
    }
  }

  Future<Map<String, int>> getProposalsByStatus(
      String userId, String period) async {
    final url =
        Uri.parse("$baseUrl/proposal/statistics/$userId?period=$period");

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      Map<String, int> statusCount = {
        'Fechado': 0,
        'Parado': 0,
        'Acompanhar': 0,
        'Negociação': 0,
      };

      for (var entry in data) {
        String statusName = entry[0];
        int count = entry[1];

        if (statusCount.containsKey(statusName)) {
          statusCount[statusName] = count;
        }
      }

      return statusCount;
    } else {
      throw Exception("Falha ao carregar dados de status");
    }
  }
}