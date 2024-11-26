import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';

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

    Future<List<Map<String, dynamic>>> getAllStatusProposals() async {
    final url = Uri.parse('$baseUrl/statusProposal');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((status) => {
          'idStatusProposal': status['idStatusProposal'],
          'name': status['name'],
        }).toList();
      } else {
        throw Exception('Erro ao buscar status das propostas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProposals(String userId, int page, {int size = 20}) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('Usuário não autenticado.');
      }

      final url = Uri.parse('$baseUrl/proposal/all/$userId');

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

  Future<Map<String, dynamic>> fetchProposalByLeadId(int idLead) async {
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

  Future<List<Map<String, dynamic>>> fetchProposalsByName(String name, String userId) async {
  final response = await http.get(
      Uri.parse('$baseUrl/proposal/search/$name/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['content'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar leads: ${response.statusCode}');
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

  Future<void> downloadProposalFile(int idProposal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final url = Uri.parse('$baseUrl/proposal/download/$idProposal/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/proposal_$idProposal.pdf');
        await file.writeAsBytes(bytes);

        final xFile = XFile(file.path);

        await Share.shareXFiles([xFile]);

        print('Download concluído e compartilhado: ${file.path}');
      } else {
        throw Exception('Erro ao buscar arquivo da proposta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
  
  
Future<void> updateProposal(Map<String, dynamic> updatedProposalData) async {
  try {
    var uri = Uri.parse('$baseUrl/lead/${updatedProposalData['idProposal']}');
    
    var request = http.MultipartRequest('PUT', uri)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
      })
      ..fields['service'] = updatedProposalData['service']
      ..fields['proposalDate'] = updatedProposalData['proposalDate']
      ..fields['value'] = updatedProposalData['value'].toString()
      ..fields['description'] = updatedProposalData['description']
      ..fields['idStatusProposal'] = updatedProposalData['idStatusProposal'].toString();

    if (updatedProposalData['file'] != null) {
      var file = updatedProposalData['file'];
      var multipartFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multipartFile);
      print('Arquivo adicionado: ${file.path}');
    } else {
      print('Nenhum arquivo foi adicionado');
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Proposta atualizada com sucesso');
      var responseData = await response.stream.bytesToString();
      print('Resposta do servidor: $responseData');
    } else {
      throw Exception('Falha ao atualizar a proposta: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro durante a atualização da proposta: $e');
  }
}

  Future<void> deleteProposal(int idProposal) async {
    final url = Uri.parse('$baseUrl/proposal/delete/$idProposal');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar proposta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro na requisição delete: $e');
    }
  }
}