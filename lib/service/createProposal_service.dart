import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProposalService {
  String baseUrl = 'http://grupo04.duckdns.org:8080';

Future<void> postNewProposal({
    required int idLead,
    required String description,
    required String completionDate,
    required String service,
    required double value,
    required int idStatusProposal,
    required File file,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('$baseUrl/proposal');

    final request = http.MultipartRequest('POST', url)
      ..fields['idLead'] = idLead.toString()
      ..fields['description'] = description
      ..fields['completionDate'] = completionDate
      ..fields['service'] = service
      ..fields['value'] = value.toString()
      ..fields['idStatusProposal'] = idStatusProposal.toString()
      ..fields['user'] = jsonEncode({"idUser": userId});

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Proposta criada com sucesso.');
      } else {
        print('Erro ao criar proposta: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

Future<List<dynamic>> getAllStatusProposals() async {
  final url = Uri.parse('$baseUrl/statusProposal');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Erro ao buscar status das propostas: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro: $e');
  }
}
}