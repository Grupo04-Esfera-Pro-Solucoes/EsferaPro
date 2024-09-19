import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  static Future<http.Response> postNewUser({
    required String username,
    required String password,
    required String email,
    required String phone,
    required String role,
  }) async {
    final url = Uri.parse('http://localhost:8080/register');

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