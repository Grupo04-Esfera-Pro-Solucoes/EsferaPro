import 'package:esferapro/screens/stacks/stack_proposalCadastro.dart';
import 'package:esferapro/screens/stacks/stack_proposalEdit.dart';
import 'package:esferapro/service/proposal_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Proposal extends StatefulWidget {
  @override
  _ProposalState createState() => _ProposalState();
}

class _ProposalState extends State<Proposal> {
  final ProposalService proposalService = ProposalService();
  List<Map<String, dynamic>> proposals = [];
  bool isLoading = true;
  String? errorMessage;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      if (userId != null) {
        _fetchProposals();
      } else {
        isLoading = false;
        errorMessage = 'Usuário não encontrado';
      }
    });
  }

  Future<void> _fetchProposals() async {
    if (userId != null) {
      try {
        final proposalsData = await proposalService.fetchAllProposals();

        setState(() {
          proposals = proposalsData;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Erro ao carregar propostas';
        });
      }
    }
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

  String _formatDayMonth(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate = "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(),
              _buildHeader(),
              Expanded(
              child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : proposals.isEmpty
                    ? const Center(child: Text('Nenhuma proposta disponível!'))
                    : ListView.builder(
                      itemCount: proposals.length,
                      itemBuilder: (context, index) {
                        final proposalData = proposals[index];
                        return _buildProposalTile(context, proposalData);
                      },
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StackProposalCadastro()),
          ).then((success) {
            if (success == true) {
              _fetchProposals();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ligação cadastrada com sucesso!'),
                  backgroundColor: Color(0xFF6502D4),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          });
              },
              backgroundColor: const Color.fromRGBO(101, 2, 212, 1),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    TextEditingController searchController = TextEditingController();
    return Container(
      color: const Color(0xFFEAECF0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Digite sua pesquisa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: const Color.fromRGBO(101, 2, 212, 1), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: const Color.fromRGBO(101, 2, 212, 1), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: const Color.fromRGBO(101, 2, 212, 1), width: 2.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color.fromRGBO(101, 2, 212, 1)),
            onPressed: () {
              // Aqui você pode implementar a lógica de busca usando o texto de searchController
              String searchQuery = searchController.text;
              debugPrint('Buscar: $searchQuery'); // Exemplo de uso
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: const Color(0xFFEAECF0),
      child: Row(
        children: const [
          Expanded(flex: 3, child: Text('Cliente', textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0))),
          Expanded(flex: 2, child: Text('Valor', textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0))),
          Expanded(flex: 1, child: Text('Data', textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0))),
          Expanded(flex: 2, child: Text('Ações', textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0))),
        ],
      ),
    );
  }

  Widget _buildProposalTile(BuildContext context, Map<String, dynamic> proposalData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    _getStatusIcon(proposalData['idStatusProposal']?['id'] ?? 0),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: Text(
                        proposalData['idClient']?['name'] ?? 'Sem Nome',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Text(proposalData['value'] != null ? proposalData['value'].toStringAsFixed(2) : 'N/A', textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Text(_formatDayMonth(proposalData['proposalDate'] ?? ''), textAlign: TextAlign.center)),
              Expanded(
                flex: 2,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StackProposalEdit(
                                proposalData: proposalData,
                                onEdit: (updatedProposalData) async {
                                  try {
                                    updatedProposalData['idProposal'] = proposalData['idProposal'];
                                    await proposalService
                                    .updateProposal(updatedProposalData,);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Proposta atualizada com sucesso'),
                                        backgroundColor: Color(0xFF6502D4),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erro ao atualizar a proposta'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                onDelete: (String idProposal) async {
                                  try {
                                    await proposalService.deleteProposal(int.parse(idProposal));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Proposta excluída com sucesso!'),
                                        backgroundColor: Color(0xFF6502D4),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erro ao excluir a proposta'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ).then((_) {
                            _fetchProposals();
                          });
                        },
                        icon: const Icon(Icons.edit, color: Colors.black),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        onPressed: () => _showProposalDetails(context, proposalData),
                        icon: const Icon(Icons.visibility, color: Colors.black),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xffD3D3D3),
          thickness: 1.0,
          height: 1.0,
        ),
      ],
    );
  }

void _showProposalDetails(BuildContext context, Map<String, dynamic> proposalData) async {
    final proposal = proposalData;
    final client = proposal['idLead']?['idClient'];
    final status = proposal['idStatusProposal'];
    final file= proposal['file'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Detalhes da Proposta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                _buildDetailRow('Cliente:', client?['name'] ?? 'N/A'),
                _buildDetailRow('Status:', status?['name'] ?? 'N/A'),
                _buildDetailRow('Data:', _formatDate(proposal['proposalDate'])),
                _buildDetailRow('Valor:', 'R\$ ${proposal['value'] != null ? proposal['value'].toStringAsFixed(2) : 'N/A'}'),
                _buildDetailRow('Descrição:', proposal['description'] ?? 'N/A'),
                GestureDetector(
                  onTap: () async {
                  if (file != null) {
                    final proposalService = ProposalService();
                    await proposalService.downloadProposalFile(proposal['idProposal']);
                  }
                  },
                  child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                    TextSpan(
                      text: 'Anexo: ',
                      style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: file != null ? 'Clique para baixar' : 'Proposta sem anexo',
                      style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xff6502d4),
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      ),
                    ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xff6502d4), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                ),
                child: const Text(
                  'Fechar',
                  style: TextStyle(color: Color(0xff6502d4), fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$title ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
