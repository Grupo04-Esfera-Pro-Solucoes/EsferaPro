import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProposalService {
  String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8080';

  Future<void> postNewProposal({
    required int idLead,
    required String completionDate,
    required int idStatusProposal,
    required String clientId,
    String? clientName,
    String? description,
    String? service,
    double? value,
    File? file,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('$baseUrl/proposal');

    final request = http.MultipartRequest('POST', url)
      ..fields['idLead'] = idLead.toString()
      ..fields['completionDate'] = completionDate
      ..fields['idStatusProposal'] = idStatusProposal.toString()
      ..fields['clientId'] = clientId;

    if (description != null) {
      request.fields['description'] = description;
    }
    if (service != null) {
      request.fields['service'] = service;
    }
    if (value != null) {
      request.fields['value'] = value.toString();
    }
    if (clientName != null) {
      request.fields['clientName'] = clientName;
    }

    request.fields['user'] = jsonEncode({"idUser": userId});

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    try {
      final response = await request.send();

      if (response.statusCode != 200) {
      throw Exception('Erro ao excluir tarefa: ${response.statusCode}');
    }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchProposals() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }

      final url = Uri.parse('$baseUrl/proposal/all/$userId?page=0&size=20&sort=idProposal');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['content'];
          return data.map((item) => item as Map<String, dynamic>).toList();
        } else {
          throw Exception('Erro ao buscar propostas: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Erro: $e');
      }
    }

  Future<List<dynamic>> getAllStatusProposals() async {
    final url = Uri.parse('$baseUrl/statusProposal');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      } else {
        throw Exception('Erro ao buscar status das propostas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSearchProposalByName(int idLead) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('$baseUrl/lead/$idLead/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar proposta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProposalById(int idProposal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('$baseUrl/proposal/$idProposal/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar proposta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  Future<Map<String, dynamic>> fetchProposalForEdit(int idProposal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('$baseUrl/proposal/$idProposal/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao buscar proposta para edição: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
  
  Future<void> updateProposal({
    required int idProposal,
    required int idLead,
    required String completionDate,
    required int idStatusProposal,
    required String clientId,
    String? clientName,
    String? description,
    String? service,
    double? value,
    File? file,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception("Usuário não autenticado.");
    }

    final url = Uri.parse('$baseUrl/proposal/$idProposal');

    final request = http.MultipartRequest('PUT', url)
      ..fields['idLead'] = idLead.toString()
      ..fields['completionDate'] = completionDate
      ..fields['idStatusProposal'] = idStatusProposal.toString()
      ..fields['clientId'] = clientId;

    if (description != null) {
      request.fields['description'] = description;
    }
    if (service != null) {
      request.fields['service'] = service;
    }
    if (value != null) {
      request.fields['value'] = value.toString();
    }
    if (clientName != null) {
      request.fields['clientName'] = clientName;
    }

    request.fields['user'] = jsonEncode({"idUser": userId});

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
    }

    try {
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Erro ao atualizar proposta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }



}