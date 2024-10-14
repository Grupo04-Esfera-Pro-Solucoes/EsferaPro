import 'dart:convert';
import 'package:http/http.dart' as http;

class CallService {
  final String baseUrl = "http://grupo04.duckdns.org:8080";

  Future<void> postNewCall({
    required String name,
    required String cpfCnpj,
    required String result,
    required String duration,
    required String contactNumber,
    required String date,
    required String time,
    required String description,
  }) async {
    final url = Uri.parse('$baseUrl/lead'); 
    final Map<String, dynamic> callData = {
      'name': name,
      'cpfCnpj': cpfCnpj,
      'result': result,
      'duration': duration,
      'contact': contactNumber,
      'date': date,
      'callTime': time,
      'description': description,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(callData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Lead criado com sucesso');
      } else {
        print('Falha ao criar lead: ${response.body}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
  }
}