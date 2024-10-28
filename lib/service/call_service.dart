import 'dart:convert';
import 'package:http/http.dart' as http;

class CallService {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<void> postNewCall({
    required String name,
    required String cpfCnpj,
    required String duration,
    required String contactNumber,
    required String date,
    required String time,
    required String description,
    required String idLeadResult,
  }) async {
    final url = Uri.parse('$baseUrl/lead');
    final Map<String, dynamic> callData = {
      'name': name,
      'cpfCnpj': cpfCnpj,
      'duration': duration,
      'contact': contactNumber,
      'date': date,
      'callTime': time,
      'description': description,
      'result': {
        'idLeadResult': idLeadResult,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(callData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Falha ao criar lead: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<List<dynamic>> fetchAllClients() async {
    final url = Uri.parse('$baseUrl/client/all');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao buscar clientes: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer requisição: $e');
    }
  }

  Future<List<dynamic>> fetchLeadResults() async {
    final url = Uri.parse('$baseUrl/leadResult');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao buscar resultados: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}