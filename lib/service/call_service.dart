import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<List<Map<String, dynamic>>> fetchAllLeads(String userId, int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lead/all/$userId?page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['content'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao carregar leads: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLeadsByName(String name, String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lead/name/$name/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['content'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar leads: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchLeadResultById(String idLeadResult) async {
    final url = Uri.parse('$baseUrl/leadResult/$idLeadResult');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar result: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição fetchLeadResultById: $e');
    }
  }

  Future<Map<String, dynamic>> fetchClientById(String idClient) async {
    final url = Uri.parse('$baseUrl/client/$idClient');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar cliente: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição fetchClientById: $e');
    }
  }

  Future<void> updateLead(Map<String, dynamic> updatedCallData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/lead/${updatedCallData['idLead']}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contact': updatedCallData['contact'],
          'date': updatedCallData['date'],
          'duration': updatedCallData['duration'],
          'description': updatedCallData['description'],
          'result': updatedCallData['result'],
          'callTime': updatedCallData['callTime'],
        }),
      );

      if (response.statusCode == 200) {
        print('Lead atualizado com sucesso');
      } else {
        throw Exception('Falha ao atualizar o lead: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> deleteCall(String idLead) async {
    final url = Uri.parse('$baseUrl/lead/delete/$idLead');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar ligação: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição delete: $e');
    }
  }
}