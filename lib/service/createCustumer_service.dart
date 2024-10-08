import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<void> postNewUser({
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

    final url = Uri.parse('http://grupo04.duckdns.org:8080/client-address-contact/add');

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
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        print('Sucesso: ${utf8.decode(response.bodyBytes)}');
      } else {
        print('Erro: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('Erro ao enviar: $e');
    }
  }
}
