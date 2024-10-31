import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Future<bool> serverConection() async {
    final url = Uri.parse('$_baseUrl/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Falha na conexão.');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar com o servidor.');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    if (!await serverConection()) {
      print('Servidor offline.');
      return false;
    }

    final url = Uri.parse('$_baseUrl/login');
    final Map<String, dynamic> dados = {'email': email, 'password': password};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final userId = json.decode(response.body)['idUser'];
        await prefs.setInt('userId', userId);
        return true;
      } else {
        print('Falha no login.');
        return false;
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return false;
    }
  }
}