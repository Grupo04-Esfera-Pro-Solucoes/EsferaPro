import 'package:esferapro/screens/stacks/stack_calls.dart';
import 'package:flutter/material.dart';
import 'package:esferapro/service/call_service.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final CallService callService = CallService();
  List<dynamic> calls = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchCallData() async {
    try {
      final data = await callService.fetchCalls();
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

  @override
  void initState() {
    super.initState();
    fetchCallData();
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
                            ? const Center(child: Text('Nenhuma ligação disponível!'))
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
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.purple),
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
              child: Text('ID', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Descrição', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Opções', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallTile(BuildContext context, Map<String, dynamic> callData) {
    final lead = callData['lead'] ?? {};

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                lead['idLead']?.toString() ?? 'Sem ID',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                lead['description'] ?? 'Sem Descrição',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () => _showCallDetails(context, callData),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(const Color(0xffe5e5e5)),
              ),
              child: const Icon(Icons.info, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showCallDetails(BuildContext context, Map<String, dynamic> callData) {
    final lead = callData['lead'] ?? {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Call Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lead Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('ID: ${lead['idLead'] ?? 'No ID'}'),
                Text('Descrição: ${lead['description'] ?? 'Sem descrição'}'),
                Text('Criado em: ${lead['creationDate'] ?? 'Sem data'}'),
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