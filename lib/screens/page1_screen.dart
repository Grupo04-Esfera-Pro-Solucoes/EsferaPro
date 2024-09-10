
import 'dart:convert'; // Para decodificar a resposta JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('http://localhost:8080/client-address-contact/all/1'); // Use 10.0.2.2 para Android emulator

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched data: ${json.encode(data)}');

        setState(() {
          clients = data['content']; // Obtém a lista de clientes
          isCheckedList = List<bool>.filled(clients.length, false); // Inicializa a lista de checkboxes
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load client data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load client data'; // Mensagem de erro
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClientData(); // Busca os dados ao iniciar a página
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
      appBar: AppBar(
        title: Text('Client List'),
      ),
      body: Column(
        children: [
          _buildHeader(), // Cabeçalho
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : clients.isEmpty
                        ? Center(child: Text('No client data available'))
                        : ListView.builder(
                            itemCount: clients.length,
                            itemBuilder: (context, index) {
                              final clientData = clients[index];
                              return _buildClientTile(context, clientData, index);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  // Widget para exibir o cabeçalho com os títulos das colunas
  Widget _buildHeader() {
    return Container(
      color: Colors.blueGrey[100],
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Center(child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
          Expanded(child: Center(child: Text('Wsp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
          Expanded(child: Center(child: Text('Opções', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
        ],
      ),
    );
  }

Widget _buildClientTile(BuildContext context, Map<String, dynamic> clientData, int index) {
  final client = clientData['client'];
  final contacts = clientData['contact'];

  return Container(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // Alinha todos os itens à esquerda
      children: [
        // Checkbox colado no canto, não precisa de expansão
        Container(
          margin: EdgeInsets.only(right: 8.0), // Espaço entre o checkbox e o conteúdo
          child: Checkbox(
            value: isCheckedList[index],
            onChanged: (bool? newValue) {
              if (newValue != null) {
                _updateCheckbox(index, newValue);
              }
            },
          ),
        ),
        // Nome do cliente alinhado à esquerda e dividindo o espaço
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              client['name'] ?? 'No name',
              textAlign: TextAlign.left,
            ),
          ),
        ),
        // CPF do cliente alinhado à esquerda e dividindo o espaço
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              contacts[1]['data'] ?? 'No CPF',
              textAlign: TextAlign.left,
            ),
          ),
        ),
        // Botão "Ver Mais" alinhado à esquerda e dividindo o espaço
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => _showClientDetails(context, clientData),
              child: Text('Ver Mais'),
            ),
          ),
        ),
      ],
    ),
  );
}



  // Função para exibir um modal com mais informações
  void _showClientDetails(BuildContext context, Map<String, dynamic> clientData) {
    final client = clientData['client'];
    final address = clientData['address'];
    final contacts = clientData['contact'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('More Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Client Details:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Name: ${client['name'] ?? 'No name'}'),
                Text('CPF/CNPJ: ${client['cpfCnpj'] ?? 'No CPF/CNPJ'}'),
                Text('Company: ${client['company'] ?? 'No company'}'),
                Text('Role: ${client['role'] ?? 'No role'}'),
                Text('Date: ${client['formattedDate'] ?? 'No date'}'),
                SizedBox(height: 10),
                Text('Address:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Street: ${address['street'] ?? 'No street'}'),
                Text('Number: ${address['number'] ?? 'No number'}'),
                Text('City: ${address['city'] ?? 'No city'}'),
                Text('State: ${address['state'] ?? 'No state'}'),
                Text('Zip Code: ${address['zipCode'] ?? 'No zip code'}'),
                Text('Country: ${address['country'] ?? 'No country'}'),
                SizedBox(height: 10),
                Text('Contacts:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...contacts.map<Widget>((contact) {
                  final type = contact['idTypeContact']?['type'] ?? 'Unknown';
                  final data = contact['data'] ?? 'No data';
                  return ListTile(
                    leading: Icon(Icons.contact_phone),
                    title: Text('Type: $type'),
                    subtitle: Text('Contact: $data'),
                  );
                }).toList(),
                if (contacts.isEmpty) Text('No contacts available'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
