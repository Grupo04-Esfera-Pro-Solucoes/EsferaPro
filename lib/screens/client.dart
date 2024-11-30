import 'package:esferapro/screens/stacks/client_edit.dart';
import 'package:esferapro/service/client_service.dart';
import 'package:flutter/material.dart';
import 'package:esferapro/screens/stacks/stack_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final ClientService clientService = ClientService();
  List<dynamic> client = [];
  List<bool> isCheckedList = [];
  bool isLoading = true;
  String? errorMessage;
  int? userId;
  TextEditingController searchController = TextEditingController();

  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 20;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchClientData();
  }

  Future<void> _fetchClients() async {
    try {
      final data = await clientService.fetchClientData();
      setState(() {
        client = data;
      });
    } catch (e) {
      print("Erro ao buscar clientes: $e");
    }
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      if (userId != null) {
        isLoading = false;
      } else {
        isLoading = false;
        errorMessage = 'Usuário não encontrado';
      }
    });
  }

  Future<void> fetchClientData({String? searchQuery}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final clients =
          await clientService.fetchClientData(searchQuery: searchQuery);
      setState(() {
        client = clients;
        isCheckedList = List<bool>.filled(client.length, false);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load client data';
      });
    }
  }

  void _searchClient() {
    setState(() {
      client = [];
      isLoading = true;
    });
    fetchClientData(searchQuery: searchController.text.trim());
  }

  Future<void> _nextPage() async {
    if (hasMoreData) {
      setState(() {
        currentPage++;
        isLoading = true;
      });
      await fetchClientData();
    }
  }

  Future<void> _previousPage() async {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        isLoading = true;
      });
      await fetchClientData();
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
                        : client.isEmpty
                            ? const Center(
                                child: Text('Nenhum Cliente Disponível!'))
                            : ListView.builder(
                                itemCount: client.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == client.length) {
                                    return _buildPaginationControls();
                                  }
                                  final clientData = client[index];
                                  return _buildClientTile(
                                      context, clientData, index);
                                },
                              ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StackClients()),
          ).then((success) {
            if (success == true) {
              _searchClient();
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                    onPressed: _searchClient,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Cliente', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Telefone', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text('Ações', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientTile(
    BuildContext context,
    Map<String, dynamic> clientData,
    int index,
  ) {
    final client = clientData['client'] ?? {};
    final contacts = clientData['contact'] ?? [];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    client['name'] ?? 'No name',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    contacts.isNotEmpty && contacts[0]['data'] != null
                        ? contacts[0]['data']
                        : 'No CPF',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientEdit(
                                clientData: clientData,
                                onEdit: (updatedClientData) async {
                                  try {
                                    final clientId =
                                        updatedClientData['client']['id'];
                                    final name =
                                        updatedClientData['client']['name'];
                                    final cpfCnpj =
                                        updatedClientData['client']['cpfCnpj'];
                                    final company =
                                        updatedClientData['client']['company'];
                                    final role =
                                        updatedClientData['client']['role'];
                                    final date =
                                        updatedClientData['client']['date'];

                                    final address =
                                        updatedClientData['address'];

                                    final contacts =
                                        updatedClientData['contact'];

                                    await clientService.updateClient(
                                      clientId: clientId,
                                      name: name,
                                      cpfCnpj: cpfCnpj,
                                      company: company,
                                      role: role,
                                      date: date,
                                      address: address,
                                      contacts: contacts,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Client updated successfully'),
                                        backgroundColor: Color(0xFF6502D4),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to update client: $e'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                onDelete: (String idClient) async {
                                  if (userId == null) {
                                    await _loadUserId();
                                  }

                                  if (userId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Usuário não encontrado'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    final clientId = int.parse(idClient);

                                    await clientService.deleteClient(
                                        clientId: clientId, userId: userId!);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Cliente deletado com sucesso'),
                                        backgroundColor: Color(0xFF6502D4),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Falha ao deletar cliente'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ).then((_) {
                          _fetchClients();
                        });
                      },
                      icon: const Icon(Icons.edit, color: Colors.black),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      onPressed: () => _showClientDetails(context, clientData),
                      icon: const Icon(Icons.visibility, color: Colors.black),
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      onPressed: () {
                        if (contacts.isNotEmpty &&
                            contacts[0]['data'] != null) {
                          _openWhatsApp(contacts[0]['data']);
                        }
                      },
                      icon: Image.asset(
                        'assets/zap.png',
                        height: 22,
                        width: 22,
                      ),
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
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }

  void _showClientDetails(
      BuildContext context, Map<String, dynamic> clientData) {
    final client = clientData['client'] ?? {};
    final address = clientData['address'] ?? {};
    final contacts = clientData['contact'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Detalhes do Cliente',
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
                const Text('Cliente:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildDetailRow('Name:', ' ${client['name'] ?? 'No name'}'),
                _buildDetailRow(
                    'CPF/CNPJ', ' ${client['cpfCnpj'] ?? 'No CPF/CNPJ'}'),
                _buildDetailRow(
                    'Company', ' ${client['company'] ?? 'No company'}'),
                _buildDetailRow('Role', ' ${client['role'] ?? 'No role'}'),
                _buildDetailRow(
                    'Date', ' ${client['formattedDate'] ?? 'No date'}'),
                const SizedBox(height: 10),
                const Text('Endereço:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildDetailRow(
                    'Street', ' ${address['street'] ?? 'No street'}'),
                _buildDetailRow(
                    'Number', ' ${address['number'] ?? 'No number'}'),
                _buildDetailRow('City', ' ${address['city'] ?? 'No city'}'),
                _buildDetailRow('State', ' ${address['state'] ?? 'No state'}'),
                _buildDetailRow(
                    'Zip Code', ' ${address['zipCode'] ?? 'No zip code'}'),
                _buildDetailRow(
                    'Country', ' ${address['country'] ?? 'No country'}'),
                const SizedBox(height: 10),
                const Text('Contato:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (contacts.isNotEmpty)
                  ...contacts.map<Widget>((contact) {
                    final data = contact['data'] ?? 'No data';
                    return _buildDetailRow('Número:', '$data');
                  }).toList()
                else
                  const Text('No contacts available'),
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

  void _openWhatsApp(String number) async {
    String formattedNumber = number.replaceAll(RegExp(r'[\s\(\)\-]'), '');
    print(formattedNumber);
    final String url = 'https://wa.me/$formattedNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp';
    }
  }
}
