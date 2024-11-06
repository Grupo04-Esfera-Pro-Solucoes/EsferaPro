import 'package:esferapro/widgets/call_dialog.dart';
import 'package:flutter/material.dart';
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
    return DateFormat('dd/MM').format(parsedDate);
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
                    onPressed: () {},
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Expanded(
            child: Column(
              children: [
                Text('Cliente', style: TextStyle(fontSize: 18)),
                SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Resultado', style: TextStyle(fontSize: 18)),
                SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Data     ', style: TextStyle(fontSize: 18)),
                SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Info        ', style: TextStyle(fontSize: 18)),
                SizedBox(height: 4),
              ],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      callData['idClient']['name'] ?? 'Sem Nome',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      callData['result']['result'] ?? 'Sem Resultado',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      _formatDate(callData['date'] ?? '0000-00-00'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _showCallDialog(context, callData),
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

  void _showCallDetails(BuildContext context, Map<String, dynamic> callData) async {
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
                _buildDetailRow('Resultado:', callData['result']['result'] ?? 'N/A'),
                _buildDetailRow('Data:', _formatDate(callData['date'] ?? '0000-00-00')),
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

  void _showCallDialog(BuildContext context, Map<String, dynamic> callData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CallDialog(
          callData: callData,
          onEdit: (updatedCallData) {
            setState(() {
              final index =
                  calls.indexWhere((call) => call['id'] == callData['id']);
              if (index != -1) {
                calls[index] = {...calls[index], ...updatedCallData};
              }
            });
          },
          onDelete: () {
            setState(() {
              calls.removeWhere((call) => call['id'] == callData['id']);
            });
          },
        );
      },
    );
  }
}
