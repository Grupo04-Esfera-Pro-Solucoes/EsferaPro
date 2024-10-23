import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'stack_pages/stack_proposal.dart';

class Proposal extends StatefulWidget {
  @override
  _ProposalState createState() => _ProposalState();
}

class _ProposalState extends State<Proposal> {
  List<Map<String, dynamic>> proposals = [];

  @override
  void initState() {
    super.initState();
    _fetchProposals();
  }

  Future<void> _fetchProposals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      _showErrorSnackBar('Usuário não autenticado.');
      return;
    }

    try {
      final response = await http.get(Uri.parse('http://localhost:8080/proposal/all/$userId?page=0&size=20&sort=idProposal'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['content'];
        setState(() {
          proposals = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        _showErrorSnackBar('Erro ao buscar propostas');
      }
    } catch (e) {
      _showErrorSnackBar('Erro: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Icon _getStatusIcon(int statusID) {
    switch (statusID) {
      case 1:
        return Icon(Icons.check_circle, color: Colors.green, size: 24.0);
      case 2:
        return Icon(Icons.cancel, color: Colors.red, size: 24.0);
      case 3:
        return Icon(Icons.access_time, color: Colors.blue, size: 24.0);
      case 4:
        return Icon(Icons.work, color: Colors.orange, size: 24.0);
      default:
        return Icon(Icons.help, color: Colors.grey, size: 24.0);
    }
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate = "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Propostas'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.grey[200],
            child: Row(
              children: const [
                Expanded(child: Text('Cliente', textAlign: TextAlign.center)),
                Expanded(child: Text('Valor', textAlign: TextAlign.center)),
                Expanded(child: Text('Data', textAlign: TextAlign.center)),
                Expanded(child: Text('Ações', textAlign: TextAlign.center)),
              ],
            ),
          ),
          Expanded(
            child: proposals.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: proposals.length,
                    itemBuilder: (context, index) {
                      final proposal = proposals[index];
                      final client = proposal['idLead']?['idClient'];
                      final statusID = proposal['idStatusProposal']?['idStatusProposal'] ?? 0;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _getStatusIcon(statusID),
                                  const SizedBox(width: 8.0),
                                  Text(client?['name'] ?? 'N/A', textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Expanded(child: Text(proposal['value']?.toString() ?? 'N/A', textAlign: TextAlign.center), flex: 2),
                            Expanded(child: Text(_formatDate(proposal['proposalDate']), textAlign: TextAlign.center), flex: 2),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Adicione a lógica de edição aqui
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      _showProposalDetails(context, proposal);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProposalCadastro()), // Navegue para ProposalCadastro
              );
            },
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Icon(
              Icons.add,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void _showProposalDetails(BuildContext context, Map<String, dynamic> proposalData) {
  final proposal = proposalData;
  final client = proposal['idLead']?['idClient'];
  final status = proposal['idStatusProposal'];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Detalhes da Proposta:'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Status: ${status?['name'] ?? 'N/A'}'),
              Text('Cliente: ${client?['name'] ?? 'N/A'}'),
              Text('Data: ${proposal['proposalDate'] ?? 'N/A'}'),
              Text('Valor: ${proposal['value']?.toString() ?? 'N/A'}'),
              Text('Descrição: ${proposal['description'] ?? 'N/A'}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
