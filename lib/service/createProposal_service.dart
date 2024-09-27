import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ProposalService{
  Future<void> postNewProposal({
    required int idLead,
    required String description,
    required String proposalDate,
    required String service,
    required double value,
    required int idStatusProposal,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('http://localhost:8080/proposal');

    final Map<String, dynamic> dados = {
      "idLead": idLead,
      "description": description,
      "proposalDate": proposalDate,
      "service": service,
      "value": value,
      "idStatusProposal": idStatusProposal,
      "user": {"idUser": userId}
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
        print('Proposta criada com sucesso.');
      } else {
        print('Erro ao criar proposta: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }



}

