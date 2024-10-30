import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterService {
  static Future<http.Response> postNewUser({
    required String username,
    required String password,
    required String email,
    required String phone,
    required String role,
  }) async {
    final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

    final url = Uri.parse('$baseUrl/register');

    final Map<String, dynamic> dados = {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'role': role
    };

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dados),
    );
  }
}