import 'package:esferapro/widgets/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientEdit extends StatefulWidget {
  final Map<String, dynamic> clientData;
  final Future<void> Function(Map<String, dynamic> updatedClientData) onEdit;
  final Future<void> Function(int) onDelete;

  const ClientEdit({
    required this.clientData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _ClientEditState createState() => _ClientEditState();
}

class _ClientEditState extends State<ClientEdit> {
  late TextEditingController nameController;
  late TextEditingController cpfCnpjController;
  late TextEditingController companyController;
  late TextEditingController roleController;
  late TextEditingController dateController;
  late TextEditingController contactNumberController;
  late TextEditingController addressNumberController;
  late TextEditingController zipCodeController;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController numberController;
  late List<Map<String, dynamic>> contactList;
  int? userId;

  @override
void initState() {
  super.initState();
  _loadUserId();

  nameController = TextEditingController(text: widget.clientData['client']?['name'] ?? '');
  cpfCnpjController = TextEditingController(text: widget.clientData['client']?['cpfCnpj'] ?? '');
  companyController = TextEditingController(text: widget.clientData['client']?['company'] ?? '');
  roleController = TextEditingController(text: widget.clientData['client']?['role'] ?? '');
  dateController = TextEditingController(
    text: widget.clientData['client']?['date'] != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.clientData['client']['date']))
        : DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  zipCodeController = TextEditingController(text: widget.clientData['address']?['zipCode'] ?? '');
  countryController = TextEditingController(text: widget.clientData['address']?['country'] ?? '');
  stateController = TextEditingController(text: widget.clientData['address']?['state'] ?? '');
  cityController = TextEditingController(text: widget.clientData['address']?['city'] ?? '');
  streetController = TextEditingController(text: widget.clientData['address']?['street'] ?? '');
  numberController = TextEditingController(text: widget.clientData['address']?['number'] ?? '');

  contactList = List<Map<String, dynamic>>.from(widget.clientData['contact'] ?? []);

  contactNumberController = TextEditingController(
    text: contactList.isNotEmpty ? contactList[0]['data'] ?? '' : '',
  );
}

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
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
                      'Editar Cliente',
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 36),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados básicos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildTitle('Nome'),
                  const SizedBox(height: 5),
                  _buildTextField(
                    controller: nameController,
                    hintText: 'Digite o nome completo',
                  ),
                  const SizedBox(height: 10),
                  _buildTitle('CPF ou CNPJ'),
                  const SizedBox(height: 5),
                  _buildTextField(
                    controller: cpfCnpjController,
                    hintText: '123.456.789-00 ou 12.345.678/0001-95',
                  ),
                  const SizedBox(height: 10),
                  _buildTitle('Empresa'),
                  const SizedBox(height: 5),
                  _buildTextField(
                    controller: companyController,
                    hintText: 'Nome da empresa',
                  ),
                  const SizedBox(height: 10),
                  _buildTitle('Cargo'),
                  const SizedBox(height: 5),
                  _buildTextField(
                    controller: roleController,
                    hintText: 'Seu cargo na empresa',
                  ),
                  const SizedBox(height: 10),
                  _buildTitle('Data de Nascimento'),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2500),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        dateController.text = formattedDate;
                      }
                    },
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: dateController,
                        hintText: '00/00/0000',
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Informações para contato',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTitle('Contato'),
                  const SizedBox(height: 5),
                  _buildTextField(
                    controller: contactNumberController,
                    hintText: '99 999999999',
                    inputFormatters: [PhoneInputFormatter()],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('CEP'),
                          const SizedBox(height: 5),
                          _buildHalfWidthTextField(
                            controller: zipCodeController,
                            hintText: '00000-00',
                            inputFormatters: [ZipCodeInputFormatter()],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('País'),
                          const SizedBox(height: 5),
                          _buildHalfWidthTextField(
                            controller: countryController,
                            hintText: 'Nome do país',
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('Estado'),
                          const SizedBox(height: 5),
                          _buildHalfWidthTextField(
                            controller: stateController,
                            hintText: 'Nome do estado',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('Cidade'),
                          const SizedBox(height: 5),
                          _buildHalfWidthTextField(
                            controller: cityController,
                            hintText: 'Nome da cidade',
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('Rua'),
                          const SizedBox(height: 5),
                          _buildHalfWidthTextField(
                            controller: streetController,
                            hintText: 'Nome da rua',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('Número'),
                          const SizedBox(height: 5),
                          _buildHalfWidthTextField(
                            controller: numberController,
                            hintText: 'Casa/Apartamento',
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomSizedElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Cancelar',
                          isCancelButton: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCustomSizedElevatedButton(
                          onPressed: () async {
                            List<Map<String, dynamic>> updatedContacts =
                                contactList.map((contact) {
                              return {
                                'data': contact['data'],
                                'idTypeContact': {
                                  'idTypeContact': 2,
                                  'type': 'telefone',
                                },
                              };
                            }).toList();
                            final updatedClientData = {
                              'client': {
                                'id': widget.clientData['client']['idClient'],
                                'name': nameController.text,
                                'cpfCnpj': cpfCnpjController.text,
                                'company': companyController.text,
                                'role': roleController.text,
                                'date': dateController.text,
                                'user': {'idUser': userId},
                              },
                              'contact': updatedContacts,
                              'address': {
                                'zipCode': zipCodeController.text,
                                'street': streetController.text,
                                'number': numberController.text,
                                'state': stateController.text,
                                'city': cityController.text,
                                'country': countryController.text,
                              }
                            };
                            await widget.onEdit(updatedClientData);
                            Navigator.pop(context);
                          },
                          text: 'Salvar',
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await widget
                            .onDelete(widget.clientData['client']['idClient']);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF6502D4),
                        elevation: 2,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.5, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Excluir',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
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

  Widget _buildCustomSizedElevatedButton({
    required VoidCallback onPressed,
    required String text,
    bool isCancelButton = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isCancelButton
              ? const BorderSide(color: Color(0xff6502D4), width: 2)
              : BorderSide.none,
        ),
        backgroundColor:
            isCancelButton ? Colors.transparent : const Color(0xff6502D4),
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
