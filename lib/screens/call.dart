import 'package:esferapro/screens/stacks/stack_calls.dart';
import 'package:flutter/material.dart';
import 'package:esferapro/service/call_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final CallService callService = CallService();
  List<dynamic> calls = [];
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
        _fetchCalls();
      } else {
        isLoading = false;
        errorMessage = 'Usuário não encontrado';
      }
    });
  }

  Future<void> _fetchCalls() async {
    if (userId != null) {
      try {
        final data = await callService.fetchAllLeads(userId.toString());

        setState(() {
          calls = data;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Erro ao carregar ligações';
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchLeadResultById(
      String idLeadResult) async {
    try {
      return await callService.fetchLeadResultById(idLeadResult);
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao buscar resultado do lead';
      });
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchClientById(String idClient) async {
    try {
      return await callService.fetchClientById(idClient);
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao buscar cliente';
      });
      return null;
    }
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        : calls.isEmpty
                            ? const Center(
                                child: Text('Nenhuma ligação disponível!'))
                            : ListView.builder(
                                itemCount: calls.length,
                                itemBuilder: (context, index) {
                                  final callData = calls[index];
                                  return _buildCallTile(context, callData);
                                },
                              ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StackCalls()),
          );
        },
        backgroundColor: const Color(0xFF6502D4),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                hintText: 'Buscar ligação',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      const BorderSide(color: Color(0xff6502d4), width: 2.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xff6502d4)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFEAECF0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Center(
                  child: Text('Cliente', style: TextStyle(fontSize: 18)))),
          Expanded(
              child: Center(
                  child: Text('Resultado', style: TextStyle(fontSize: 18)))),
          Expanded(
              child:
                  Center(child: Text('Data', style: TextStyle(fontSize: 18)))),
          Expanded(
              child:
                  Center(child: Text('Info', style: TextStyle(fontSize: 18)))),
        ],
      ),
    );
  }

  Widget _buildCallTile(BuildContext context, Map<String, dynamic> callData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    callData['idClient']['name'] ?? 'Sem Nome',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    callData['result']['result'] ?? 'Sem Resultado',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _formatDate(callData['date'] ?? '0000-00-00'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => _showCallDetails(context, callData),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xffe5e5e5)),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(8.0)),
                    shape: WidgetStateProperty.all(CircleBorder()),
                  ),
                  child:
                      const Icon(Icons.info_outline, color: Color(0xff6502d4)),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }

  void _showCallDetails(
      BuildContext context, Map<String, dynamic> callData) async {
    String clientName = 'Carregando...';
    String resultDescription = 'Carregando...';

    final clientId = callData['idClient']?.toString();
    if (clientId != null) {
      final clientData = await _fetchClientById(clientId);
      if (clientData != null) {
        clientName = clientData['name'] ?? 'N/A';
      } else {
        clientName = 'Cliente não encontrado';
      }
    }

    final leadResultId = callData['idLeadResult']?.toString();
    if (leadResultId != null) {
      final leadResultData = await _fetchLeadResultById(leadResultId);
      if (leadResultData != null) {
        resultDescription = leadResultData['description'] ?? 'N/A';
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes da Ligação'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detalhes da Ligação:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Nome do Cliente: $clientName'),
                Text('Hora da Ligação: ${callData['callTime'] ?? 'N/A'}'),
                Text('Duração: ${callData['duration'] ?? 'N/A'}'),
                Text('Descrição: ${callData['description'] ?? 'N/A'}'),
                Text('ID do Resultado: ${callData['idLeadResult'] ?? 'N/A'}'),
                Text('Descrição do Resultado: $resultDescription'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
