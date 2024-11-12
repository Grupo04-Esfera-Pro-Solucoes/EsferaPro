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
      final data = json.decode(response.body);
      return data;
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
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar');
    }
  }

  Future<Map<String, dynamic>> getProposalsByDayOfTheMonth(
      String userId) async {
    final url = Uri.parse('$baseUrl/proposal/graph/proposalmonth/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar');
    }
  }
}