import 'package:esferapro/screens/call.dart';
import 'package:esferapro/widgets/hybridCpfCnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/call_service.dart';

class StackCalls extends StatefulWidget {
  @override
  _StackCallsState createState() => _StackCallsState();
}

class _StackCallsState extends State<StackCalls> {
  final TextEditingController _clientName = TextEditingController();
  final TextEditingController _clientCpfCnpj = TextEditingController();
  final TextEditingController _callDuration = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _callDate = TextEditingController();
  final TextEditingController _callTime = TextEditingController();
  final TextEditingController _callDescription = TextEditingController();

  final CallService _callService = CallService();
  List<dynamic> clients = [];
  List<dynamic> leadResults = [];
  String? selectedClient;
  String? selectedResult;
  int? userId;
  String? selectedClientId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchLeadResults();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

 void _postNewCall() {
    if (userId == null || selectedClientId == null) return;
    try {
      final dateFormatter = DateFormat('dd/MM/yyyy');
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateFormatter.parse(_callDate.text));

      _callService.postNewCall(
        idLeadResult: selectedResult ?? '',
        idClient: selectedClientId!,
        duration: _callDuration.text,
        contactNumber: _contactNumber.text,
        date: formattedDate,
        time: _callTime.text,
        description: _callDescription.text,
      ).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CallPage()),
        );
      }).catchError((error) {
      print('Erro no POST: $error'); 
    });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de formatação de data: $e')),
      );
    }
  }

  Future<void> fetchClients() async {
    if (userId != null && _clientCpfCnpj.text.isNotEmpty) {
      String formattedCpf = _clientCpfCnpj.text.replaceAll(RegExp(r'[^\d]'), '');

      try {
        List<dynamic> fetchedClients = await _callService.fetchClients(
          cpfCnpj: formattedCpf,
          idUser: userId.toString(),
        );

        setState(() {
          clients = fetchedClients;

          if (clients.isNotEmpty) {
            _clientName.text = clients[0]['name']; 
            selectedClientId = clients[0]['idClient'].toString(); 
          }
        });
      } catch (e) {
        throw Exception('Erro na requisição: $e');
      }
    }
  }

  Future<void> fetchLeadResults() async {
    List<dynamic> fetchedResults = await _callService.fetchLeadResults();
    setState(() {
      leadResults = fetchedResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff6502d4),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Cadastro de Ligações',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações Gerais',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildTitle('CPF ou CNPJ', isRequired: true),
                      const SizedBox(height: 5),
                      HybridCpfCnpjInput(
                        controller: _clientCpfCnpj,
                        hintText: 'Digite CPF ou CNPJ',
                        onChanged: (value) {
                          fetchClients();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _buildTitle('Resultado', isRequired: true),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButton<String>(
                        value: selectedResult,
                        hint: Text(
                          selectedResult ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedResult = newValue;
                          });
                        },
                        items: leadResults.map<DropdownMenuItem<String>>((result) {
                          return DropdownMenuItem<String>(
                            value: result['idLeadResult'].toString(),
                            child: Text(result['result']),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
              const SizedBox(height: 10),
              Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _buildTitle('Nome do Cliente', isRequired: true),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      height: 50,
                      child: Text(
                        _clientName.text.isNotEmpty ? _clientName.text : 'Selecione um Cliente',
                        style: TextStyle(
                          color: _clientName.text.isNotEmpty ? Colors.black : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Duração da ligação', isRequired: true),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _callDuration,
                        hintText: '--:--',
                        inputFormatters: [MaskedInputFormatter('00:00')],
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Contato', isRequired: true),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _contactNumber,
                        hintText: '99 999999999',
                        inputFormatters: [MaskedInputFormatter('(00) 00000-0000')],
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Data da Ligação', isRequired: true),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _callDate,
                        hintText: '00/00/0000',
                        inputFormatters: [MaskedInputFormatter('00/00/0000')],
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Horário da Ligação', isRequired: true),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _callTime,
                        hintText: '00:00',
                        inputFormatters: [MaskedInputFormatter('00:00')],
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _buildTitle('Descrição', isRequired: true),
              const SizedBox(height: 5),
              _buildTextField(
                maxLines: 5,
                controller: _callDescription,
                hintText: 'Digite uma descrição...',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CustomSizedElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Cancelar',
                      isCancelButton: true,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomSizedElevatedButton(
                      onPressed: _postNewCall,
                      text: 'Cadastrar',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildHalfWidthTextField({
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
      ),
    );
  }
}

class CustomSizedElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isCancelButton;

  const CustomSizedElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isCancelButton
              ? const BorderSide(color: Color(0xff6502D4), width: 2)
              : BorderSide.none,
        ),
        backgroundColor: isCancelButton ? Colors.transparent : const Color(0xff6502D4),
        elevation: isCancelButton ? 0 : 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: isCancelButton ? const Color(0xff6502D4) : Colors.white, 
        ),
      ),
    );
  }
}