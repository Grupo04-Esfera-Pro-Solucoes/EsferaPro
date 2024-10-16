import 'dart:convert'; // Para decodificar a resposta JSON
import 'package:esferapro/screens/stack_pages/stack_clients.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<dynamic> clients = []; // Lista de clientes
  List<bool> isCheckedList = []; // Lista para o estado dos checkboxes
  bool isLoading = true; // Indicador de carregamento
  String? errorMessage; // Mensagem de erro, se houver

  // Função para buscar os dados dos clientes
  Future<void> fetchClientData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? UserId = prefs.getInt('userId');
    final url =
        Uri.parse('http://localhost:8080/client-address-contact/all/$UserId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched data: ${json.encode(data)}');

        setState(() {
          if (data['content'] != null && data['content'] is List) {
            clients = data['content'];
            isCheckedList = List<bool>.filled(clients.length, false);
          } else {
            clients = []; 
            isCheckedList = []; 
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load client data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load client data'; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClientData();
  }

  // Função para atualizar o estado do checkbox
  void _updateCheckbox(int index, bool newValue) {
    setState(() {
      isCheckedList[index] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(), // Barra de pesquisa
              _buildHeader(), // Cabeçalho
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : clients.isEmpty
                            ? const Center(
                                child: Text('No client data available'))
                            : ListView.builder(
                                itemCount: clients.length,
                                itemBuilder: (context, index) {
                                  final clientData = clients[index];
                                  return _buildClientTile(
                                      context, clientData, index);
                                },
                              ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StackClients()),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF6502D4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
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
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: Colors.purpleAccent, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
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
            onPressed: () {
              // Aqui você pode implementar a lógica de busca usando o texto de searchController
              String searchQuery = searchController.text;
              print('Buscar: $searchQuery'); // Exemplo de uso
            },
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
              child: Text('Cliente', style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Telefone', style: TextStyle(fontSize: 18)),
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

  Widget _buildClientTile(
      BuildContext context, Map<String, dynamic> clientData, int index) {
    final client = clientData['client'] ?? {};
    final contacts = clientData['contact'] ?? [];

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1, // Proporção 1 para cada célula
            child: Align(
              alignment: Alignment.center,
              child: Text(
                client['name'] ?? 'No name',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1, // Proporção 1 para cada célula
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
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _openWhatsApp(contacts[0]['data']),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/zap.png',
                        height: 24,
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffe5e5e5)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                    minimumSize: MaterialStateProperty.all(
                        Size(40, 40)), // Tamanho mínimo do botão
                  ),
                ),
                SizedBox(width: 8.0), // Espaço entre os botões
                ElevatedButton(
                  onPressed: () => _showClientDetails(context, clientData),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffe5e5e5)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                    minimumSize: MaterialStateProperty.all(Size(40, 40)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Função para exibir um modal com mais informações
  void _showClientDetails(
      BuildContext context, Map<String, dynamic> clientData) {
    final client = clientData['client'] ?? {};
    final address = clientData['address'] ?? {};
    final contacts = clientData['contact'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('More Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Client Details:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Name: ${client['name'] ?? 'No name'}'),
                Text('CPF/CNPJ: ${client['cpfCnpj'] ?? 'No CPF/CNPJ'}'),
                Text('Company: ${client['company'] ?? 'No company'}'),
                Text('Role: ${client['role'] ?? 'No role'}'),
                Text('Date: ${client['formattedDate'] ?? 'No date'}'),
                const SizedBox(height: 10),
                const Text('Address:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Street: ${address['street'] ?? 'No street'}'),
                Text('Number: ${address['number'] ?? 'No number'}'),
                Text('City: ${address['city'] ?? 'No city'}'),
                Text('State: ${address['state'] ?? 'No state'}'),
                Text('Zip Code: ${address['zipCode'] ?? 'No zip code'}'),
                Text('Country: ${address['country'] ?? 'No country'}'),
                const SizedBox(height: 10),
                const Text('Contacts:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (contacts.isNotEmpty)
                  ...contacts.map<Widget>((contact) {
                    final type = contact['idTypeContact']?['type'] ?? 'Unknown';
                    final data = contact['data'] ?? 'No data';
                    return ListTile(
                      leading: const Icon(Icons.contact_phone),
                      title: Text('Type: $type'),
                      subtitle: Text('Contact: $data'),
                    );
                  }).toList()
                else
                  const Text('No contacts available'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
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
