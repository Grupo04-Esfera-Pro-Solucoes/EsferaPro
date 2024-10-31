import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClientService {
  final String baseUrl;

  ClientService(this.baseUrl);

  Future<Map<String, dynamic>?> getClient(String clientId) async {
    final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

    final response = await http.get(Uri.parse('$baseUrl/client/$clientId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Erro: ${response.statusCode}');
      return null;
    }
  }
}
