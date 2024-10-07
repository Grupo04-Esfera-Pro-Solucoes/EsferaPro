import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:8080';

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final Map<String, dynamic> dados = {'email': email, 'password': password};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', json.decode(response.body)['idUser']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }
}