import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'stack_pages/stack_proposal.dart'; // Importe o arquivo correto

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
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/proposal/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['content'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Propostas'),
      ),
      body: proposals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: proposals.length,
              itemBuilder: (context, index) {
                final proposal = proposals[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(proposal['service'] ?? 'N/A'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cliente: ${proposal['client'] ?? 'N/A'}'),
                        Text('CPF / CNPJ: ${proposal['cpfCnpj'] ?? 'N/A'}'),
                        Text('Status: ${proposal['status'] ?? 'N/A'}'),
                        Text('Descrição: ${proposal['description'] ?? 'N/A'}'),
                        Text('Data: ${proposal['date'] ?? 'N/A'}'),
                        Text('Valor: ${proposal['value']?.toString() ?? 'N/A'}'),
                      ],
                    ),
                  ),
                );
              },
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
