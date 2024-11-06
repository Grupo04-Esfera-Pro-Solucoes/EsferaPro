import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Future<void> postNewCall({
    required String duration,
    required String contactNumber,
    required String date,
    required String time,
    required String description,
    required String idLeadResult,
    required String idClient,
  }) async {
    final url = Uri.parse('$baseUrl/lead');
    final Map<String, dynamic> callData = {
      'contact': contactNumber,
      'date': date,
      'callTime': time,
      'duration': duration,
      'description': description,
      'result': {
        'idLeadResult': idLeadResult,
      },
      'idClient': {
        'idClient': idClient,
      },
    };

    debugPrint('Dados enviados para postNewCall: ${jsonEncode(callData)}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(callData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Falha ao cadastrar ligação: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição POST: $e');
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
        throw Exception('Erro ao buscar resultados: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<List<dynamic>> fetchCalls() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final url = Uri.parse('http://10.0.2.2:8080/lead/all/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'] is List ? data['content'] : [];
      } else {
        throw Exception('Erro ao carregar ligações');
      }
    } catch (e) {
      throw Exception('Erro ao carregar ligações');
    }
  }
}