import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CallService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

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

  Future<List<dynamic>> fetchClients({
    required String cpfCnpj,
    required String idUser,
  }) async {
    final url = Uri.parse('$baseUrl/client/cpf/$cpfCnpj/$idUser');

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