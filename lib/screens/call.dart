import 'package:flutter/material.dart';
import 'package:esferapro/screens/stacks/call_edit.dart';
import 'package:esferapro/screens/stacks/stack_calls.dart';
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
  final TextEditingController searchController = TextEditingController();

  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 20;
  bool hasMoreData = true;

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

  Future<void> _nextPage() async {
    if (hasMoreData) {
      setState(() {
        currentPage++;
        isLoading = true;
      });
      await _fetchCalls();
    }
  }

  Future<void> _previousPage() async {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        isLoading = true;
      });
      await _fetchCalls();
    }
  }

  Future<void> _fetchCalls() async {
  if (userId != null) {
    try {
      final data = await callService.fetchAllLeads(
        userId.toString(),
        currentPage,
        size: pageSize,
      );
      setState(() {
        calls = data;
        isLoading = false;
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          hasMoreData = true;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao carregar ligações';
      });
    }
  }
}

  Future<void> _searchCallsByName() async {
    if (userId != null && searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      try {
        final data = await callService.fetchLeadsByName(
            searchController.text, userId.toString());
        setState(() {
          calls = data;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = 'Erro ao buscar leads';
        });
      }
    }
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM').format(parsedDate);
  }

  Icon _getResultIcon(String result) {
    switch (result) {
      case 'Atendido':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Desligado':
        return Icon(Icons.call_end, color: Colors.red);
      case 'Cx. Postal':
        return Icon(Icons.voicemail, color: Colors.orange);
      case 'Ocupado':
        return Icon(Icons.phone_callback, color: Colors.blue);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
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
                                itemCount: calls.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == calls.length) {
                                    return _buildPaginationControls();
                                  }
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
          ).then((_) {
            _fetchCalls();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ligação cadastrada com sucesso!'),
                backgroundColor: Color(0xFF6502D4),
                duration: Duration(seconds: 3),
              ),
            );
          });
        },
        backgroundColor: const Color(0xFF6502D4),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: isLoading || currentPage == 1 ? null : _previousPage,
            color: currentPage == 1 ? Colors.grey : Color(0xFF6502D4),
          ),
          Text('Página $currentPage'),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: isLoading || !hasMoreData ? null : _nextPage,
            color: !hasMoreData ? Colors.grey : Color(0xFF6502D4),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: const Color(0xFFEAECF0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: const Color(0xff6502d4), width: 2.0),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(
                    color: Color(0xff6502d4),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Color(0xff6502d4)),
                    onPressed: _searchCallsByName,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFEAECF0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Cliente', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Status', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Data', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Ações', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallTile(BuildContext context, Map<String, dynamic> callData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    callData['idClient']['name'] ?? 'Sem Nome',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: _getResultIcon(callData['result']['result'] ?? 'N/A'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    _formatDate(callData['date'] ?? '0000-00-00'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
                              builder: (context) => CallEdit(
                                callData: callData,
                                onEdit: (updatedCallData) async {
                                  try {
                                    updatedCallData['idLead'] =
                                        callData['idLead'];
                                    await callService
                                        .updateLead(updatedCallData);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Lead Atualizado com sucesso'),
                                        backgroundColor: Color(0xFF6502D4),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Erro ao atualizar o lead'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                onDelete: (String idLead) async {
                                  try {
                                    await callService.deleteCall(idLead);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Lead excluído com sucesso!'),
                                        backgroundColor: Color(0xFF6502D4),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erro ao excluir o lead'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ).then((_) {
                            _fetchCalls();
                          });
                        },
                        icon: const Icon(Icons.edit, color: Colors.black),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        onPressed: () => _showCallDetails(context, callData),
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

  void _showCallDetails(
      BuildContext context, Map<String, dynamic> callData) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Detalhes da Ligação',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    'Resultado:', callData['result']['result'] ?? 'N/A'),
                _buildDetailRow(
                    'Data:', _formatDate(callData['date'] ?? '0000-00-00')),
                _buildDetailRow('Hora:', callData['callTime'] ?? 'N/A'),
                _buildDetailRow('Duração:', callData['duration'] ?? 'N/A'),
                _buildDetailRow('Descrição:', callData['description'] ?? 'N/A'),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
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
