import 'package:esferapro/screens/stacks/stack_proposal.dart';
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
        final proposalsData = await proposalService.fetchProposals();

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
                        final proposal = proposals[index];
                        return _buildProposalItem(proposal);
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
                );
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
            icon: const Icon(Icons.search, color: const Color.fromRGBO(101, 2, 212, 1)),
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

  Widget _buildProposalItem(Map<String, dynamic> proposal) {
    final client = proposal['idLead']?['idClient'];
    final statusID = proposal['idStatusProposal']?['idStatusProposal'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _getStatusIcon(statusID),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    client?['name'] ?? 'N/A',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(proposal['value']?.toString() ?? 'N/A', textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text(_formatDayMonth(proposal['proposalDate']), textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => StackProposalEdicao(proposalId: proposal['id']),
                    ),
                  );
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
  }

//   Future<void> _downloadFile(String fileUrl, String fileName) async {
//   try {
//     // Realizando a requisição GET para obter o arquivo
//     final response = await http.get(Uri.parse(fileUrl));

//     if (response.statusCode == 200) {
//       // Obtém o diretório de documentos padrão do dispositivo
//       final directory = await getApplicationDocumentsDirectory();

//       // Define o caminho completo para salvar o arquivo
//       final filePath = '${directory.path}/$fileName.pdf';
//       final file = File(filePath);

//       await file.writeAsBytes(response.bodyBytes);

//       // Exibe uma mensagem de sucesso
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Arquivo baixado e salvo com sucesso!'))
//       );
//     } else {
//       // Exibe uma mensagem de erro se a requisição falhar
//       _showErrorSnackBar('Erro ao baixar o arquivo');
//     }
//   } catch (e) {
//     // Exibe uma mensagem de erro caso ocorra algum problema
//     _showErrorSnackBar('Erro: $e');
//   }
// }

void _showProposalDetails(BuildContext context, Map<String, dynamic> proposalData) async {
    final proposal = proposalData;
    final client = proposal['idLead']?['idClient'];
    final status = proposal['idStatusProposal'];
    final fileUrl = proposal['fileUrl'];

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
                _buildDetailRow('Data:', _formatDate(proposal['proposalDate']) ?? 'N/A'),
                _buildDetailRow('Valor:', 'R\$ ${proposal['value']?.toString() ?? 'N/A'}'),
                _buildDetailRow('Descrição:', proposal['description'] ?? 'N/A'),
                _buildDetailRow('Anexo:', fileUrl != null ? 'Clique para baixar' : 'Proposta sem anexo'),
                if (fileUrl != null)
                  TextButton(
                    onPressed: () => (),//_downloadFile(fileUrl, 'proposal_file'),
                    child: Text(
                      'Baixar Anexo',
                      style: TextStyle(color: Color(0xff6502d4)),
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
