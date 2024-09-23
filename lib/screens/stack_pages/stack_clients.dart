import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esferapro/service/createCustumer_service.dart';

class StackClients extends StatefulWidget {
  @override
  _StackClientsState createState() => _StackClientsState();
}

class _StackClientsState extends State<StackClients> {
  final TextEditingController _clientName = TextEditingController();
  final TextEditingController _clientCpfCnpj = TextEditingController();
  final TextEditingController _clientCompany = TextEditingController();
  final TextEditingController _clientRole = TextEditingController();
  final TextEditingController _clientEmail = TextEditingController();
  final TextEditingController _clientDate = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _addressZipCode = TextEditingController();
  final TextEditingController _addressStreet = TextEditingController();
  final TextEditingController _addressNumber = TextEditingController();
  final TextEditingController _addressState = TextEditingController();
  final TextEditingController _addressCity = TextEditingController();
  final TextEditingController _addressCountry = TextEditingController();

  final UserService _userService = UserService();

  void _postNewUser() {
    _userService.postNewUser(
      name: _clientName.text,
      cpfCnpj: _clientCpfCnpj.text,
      company: _clientCompany.text,
      role: _clientRole.text,
      email: _clientEmail.text,
      date: _clientDate.text,
      contactNumber: _contactNumber.text,
      addressNumber: _addressNumber.text,
      zipCode: _addressZipCode.text,
      street: _addressStreet.text,
      state: _addressState.text,
      city: _addressCity.text,
      country: _addressCountry.text,
    ).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.person_add,
            color: Colors.yellow,
          ),
          backgroundColor: Color(0xff6502d4),
          title: const Text('Cadastro de cliente'),
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 36.0),
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
                    const SizedBox(height: 20),
                    _buildTitle('Nome'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _clientName,
                      hintText: 'Nome do cliente',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('CPF ou CNPJ'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _clientCpfCnpj,
                      hintText: 'CPF/CNPJ',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('Empresa'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _clientCompany,
                      hintText: 'Nome da empresa',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('Cargo'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _clientRole,
                      hintText: 'Cargo do cliente',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('Data de Nascimento'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _clientDate,
                      hintText: 'dd/mm/aaaa',
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const Text(
                      'Informações para contato',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTitle('Email'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _clientEmail,
                      hintText: 'exemplo@email.com',
                    ),
                    const SizedBox(height: 20),
                    _buildTitle('Contato'),
                    const SizedBox(height: 5),
                    _buildTextField(
                        controller: _contactNumber,
                        hintText: "(99) 99999-9999"),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const Text(
                      'Endereço',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('CEP'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _addressZipCode,
                              hintText: '99999-99',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Pais'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _addressCountry,
                              hintText: 'Brasil',
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(height: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Estado'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _addressState,
                              hintText: 'Parana',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Cidade'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _addressCity,
                              hintText: 'Cidade x',
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(height: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Rua'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _addressStreet,
                              hintText: 'Rua x',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Número'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _addressNumber,
                              hintText: '00',
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Color(0xff475467)), 
                              ),
                              backgroundColor: Colors.white, 
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Color(0xff475467),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomSizedElevatedButton(
                            onPressed: () {
                              _postNewUser();
                            },
                            text: 'Salvar',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ])),
        ));
  }

  Widget _buildTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Text(
          '*',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Color(0xfff0f0f7),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildHalfWidthTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Color(0xfff0f0f7),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class CustomSizedElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomSizedElevatedButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // mesma largura do TextField
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color(0xFF6502D4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
