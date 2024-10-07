import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallService {
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    final url = Uri.parse('http://localhost:8080');

    final Map<String, dynamic> dados = {
      "client": {
        "name": name,
        "cpfCnpj": cpfCnpj,
        "result": result,
        "duration": duration,
        "contactNumber": contactNumber,
        "date": date,
        "time": time,
        "description": description,
        "user": {"idUser": userId}
      },
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
