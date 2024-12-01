import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClientService {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Future<void> postNewClient({
    required String name,
    required String cpfCnpj,
    required String company,
    required String role,
    required String email,
    required String date,
    required String contactNumber,
    required String addressNumber,
    required String zipCode,
    required String street,
    required String state,
    required String city,
    required String country,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    final url = Uri.parse('$baseUrl/client-address-contact/add');

    final Map<String, dynamic> dados = {
      "client": {
        "name": name,
        "cpfCnpj": cpfCnpj,
        "company": company,
        "role": role,
        "email": email,
        "date": date,
        "user": {"idUser": userId}
      },
      "contact": [
        {
          "data": contactNumber,
          "idTypeContact": {"idTypeContact": 2, "type": "telefone"}
        }
      ],
      "address": {
        "zipCode": zipCode,
        "street": street,
        "number": addressNumber,
        "state": state,
        "city": city,
        "country": country
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao criar cliente: $e');
    }
  }

  Future<List<dynamic>> fetchClientData(
      {String? searchQuery, int page = 0, int size = 20}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    final url = searchQuery != null && searchQuery.isNotEmpty
        ? Uri.parse(
            '$baseUrl/client-address-contact/name/$searchQuery/$userId?page=$page&size=$size')
        : Uri.parse(
            '$baseUrl/client-address-contact/all/$userId?page=$page&size=$size');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'] ?? [];
      } else {
        throw Exception('Failed to load client data');
      }
    } catch (e) {
      throw Exception('Failed to load client data: $e');
    }
  }

  Future<Map<String, dynamic>> getClient({
    required int clientId,
    required int userId,
  }) async {
    final String url = '$baseUrl/client-address-contact/$clientId/$userId';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Erro ao buscar cliente: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }

  Future<void> updateClient({
    required int clientId,
    required String name,
    required String cpfCnpj,
    required String company,
    required String role,
    required String email,
    required String date,
    required String contactNumber,
    required String addressNumber,
    required String zipCode,
    required String street,
    required String state,
    required String city,
    required String country,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    
    final String url = '$baseUrl/client-address-contact/update/$clientId';

    final Map<String, dynamic> requestData = {
      "client": {
        "name": name,
        "cpfCnpj": cpfCnpj,
        "company": company,
        "role": role,
        "email": email,
        "date": date,
        "user": {"idUser": userId}
      },
      "contact": [
        {
          "data": contactNumber,
          "idTypeContact": {"idTypeContact": 2, "type": "telefone"}
        }
      ],
      "address": {
        "zipCode": zipCode,
        "street": street,
        "number": addressNumber,
        "state": state,
        "city": city,
        "country": country
      }
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Erro ao atualizar cliente: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar cliente: $e');
    }
  }

  Future<void> deleteClient({
    required int clientId,
    required int userId,
  }) async {
    final String url =
        '$baseUrl/client-address-contact/delete/$clientId/$userId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Cliente deletado com sucesso!");
      } else if (response.statusCode == 400) {
        throw Exception('Cliente não encontrado!');
      } else if (response.statusCode == 409) {
        throw Exception(
            'Existem leads associados a este cliente, não é possível deletar');
      } else {
        throw Exception(
            'Erro ao deletar cliente: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar cliente: $e');
    }
  }
}
