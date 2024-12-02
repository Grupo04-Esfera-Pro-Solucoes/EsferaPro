import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigurationService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Future<Map<String, dynamic>?> fetchUserData(int userId) async {
    final url = Uri.parse('$baseUrl/user/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar dados do usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  Future<bool> validateCurrentPassword(int userId, String currentPassword) async {
    final url = Uri.parse('$baseUrl/user/$userId/checkPassword?currentPassword=$currentPassword');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data == true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao validar senha atual: $e');
      return false;
    }
  }

  Future<bool> updateUserInfo({
    required int userId,
    required String name,
    required String role,
    required String email,
    required String phone,
    String? newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/user/$userId');

    final Map<String, dynamic> dados = {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'passwordHash': newPassword,
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = json.decode(response.body)['message'] ?? 'Erro desconhecido';
        throw Exception('Erro ao atualizar informações do usuário: $error');
      }
    } catch (e) {
      print('Erro ao atualizar informações do usuário: $e');
      return false;
    }
  }
}
