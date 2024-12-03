import 'package:shared_preferences/shared_preferences.dart';
import 'package:esferapro/screens/stacks/stack_client.dart';
import 'package:esferapro/screens/stacks/client_edit.dart';
import 'package:esferapro/service/client_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

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

  Future<void> fetchClientData({String? searchQuery}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final clients = await clientService.fetchClientData(
        searchQuery: searchQuery ?? searchController.text.trim(),
        page: currentPage - 1,
        size: pageSize,
      );
      setState(() {
        client = clients;
        isCheckedList = List<bool>.filled(client.length, false);
        isLoading = false;
        hasMoreData = clients.length == pageSize;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Falha ao carregar dados dos clientes';
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
      });
      await fetchClientData(searchQuery: searchController.text.trim());
    }
  }

  Future<void> _previousPage() async {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      await fetchClientData(searchQuery: searchController.text.trim());
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
        onPressed: () async {
          // Aguarda o retorno da página do Stack
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StackClients(),
            ),
          );
          // Chama a função de busca de clientes após o retorno
          Future.delayed(Duration(milliseconds: 30), () {
            print("\n\n\n\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n\n\n\n");
            _searchClient();
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
                  child: FittedBox(
                    fit: BoxFit
                        .scaleDown, // Ajusta o tamanho do texto para caber no espaço
                    child: Text(
                      contacts.isNotEmpty && contacts[0]['data'] != null
                          ? contacts[0]['data']
                          : 'No CPF',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.getInt('userId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientEdit(
                              clientData: {
                                'client': clientData['client'],
                                'contact': [
                                  contacts.isNotEmpty ? contacts[0] : {}
                                ],
                                'address': clientData['address'],
                              },
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
                                  final contactNumber =
                                      updatedClientData['contact'].isNotEmpty
                                          ? updatedClientData['contact'][0]
                                              ['data']
                                          : '';
                                  final address = updatedClientData['address'];

                                  await clientService.updateClient(
                                    clientId: clientId,
                                    name: name,
                                    cpfCnpj: cpfCnpj,
                                    company: company,
                                    role: role,
                                    date: date,
                                    contactNumber: contactNumber,
                                    addressNumber: address['number'],
                                    zipCode: address['zipCode'],
                                    street: address['street'],
                                    state: address['state'],
                                    city: address['city'],
                                    country: address['country'],
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Cliente atualizado com sucesso'),
                                      backgroundColor: Color(0xFF6502D4),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Cliente atualizado com sucesso'),
                                      backgroundColor: Color(0xFF6502D4),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                              onDelete: (int idClient) async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final userId = prefs.getInt('userId');
                                if (userId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Usuário não encontrado'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await clientService.deleteClient(
                                      clientId: idClient, userId: userId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Cliente deletado com sucesso'),
                                      backgroundColor: Color(0xFF6502D4),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Erro ao deletar cliente: $e'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ).then((_) {
                          fetchClientData();
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
                _buildDetailRow('Nome:', ' ${client['name'] ?? 'No name'}'),
                _buildDetailRow(
                    'CPF/CNPJ:', ' ${client['cpfCnpj'] ?? 'No CPF/CNPJ'}'),
                _buildDetailRow(
                    'Empresa:', ' ${client['company'] ?? 'No company'}'),
                _buildDetailRow('Cargo:', ' ${client['role'] ?? 'No role'}'),
                _buildDetailRow(
                    'Data:', ' ${client['formattedDate'] ?? 'No date'}'),
                const SizedBox(height: 10),
                const Text('Endereço:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildDetailRow('Rua:', ' ${address['street'] ?? 'No street'}'),
                _buildDetailRow(
                    'Número:', ' ${address['number'] ?? 'No number'}'),
                _buildDetailRow('Cidade:', ' ${address['city'] ?? 'No city'}'),
                _buildDetailRow(
                    'Estado:', ' ${address['state'] ?? 'No state'}'),
                _buildDetailRow(
                    'CEP:', ' ${address['zipCode'] ?? 'No zip code'}'),
                _buildDetailRow(
                    'País:', ' ${address['country'] ?? 'No country'}'),
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
    // Clean up the phone number by removing spaces, parentheses, and dashes
    String formattedNumber = number.replaceAll(RegExp(r'[\s\(\)\-]'), '');

    if (!formattedNumber.startsWith('+')) {
      formattedNumber = '+55$formattedNumber';
    }

    final Uri url = Uri.parse('https://wa.me/$formattedNumber');

    try {
      await launchUrl(url);
    } catch (e) {
      print("Erro ao tentar abrir o WhatsApp: $e");
    }
  }
}
