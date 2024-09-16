import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String _baseUrl = 'http://localhost:8080/login';

  Future<bool> login(String email, String password) async {
    final Uri url = Uri.parse(_baseUrl);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['success'] as bool;
    } else {
      throw Exception('Falha ao fazer login: ${response.reasonPhrase}');
    }
  }
}