import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/input_formatters.dart';
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
                    'Cadastrar Cliente',
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
                controller: _clientName,
                hintText: 'Digite o nome completo',
              ),
              const SizedBox(height: 10),
              _buildTitle('CPF ou CNPJ'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _clientCpfCnpj,
                hintText: '123.456.789-00 ou 12.345.678/0001-95',
              ),
              const SizedBox(height: 10),
              _buildTitle('Empresa'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _clientCompany,
                hintText: 'Nome da empresa',
              ),
              const SizedBox(height: 10),
              _buildTitle('Cargo', isRequired: false),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _clientRole,
                hintText: 'Seu cargo na empresa',
              ),
              const SizedBox(height: 10),
              _buildTitle('Data de Nascimento', isRequired: false),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _clientDate,
                hintText: '00/00/0000',
                inputFormatters: [DateInputFormatter()],
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
              _buildTitle('Email'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _clientEmail,
                hintText: 'exemplo@email.com',
              ),
              const SizedBox(height: 10),
              _buildTitle('Contato'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: _contactNumber,
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
                      _buildTitle('CEP', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _addressZipCode,
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
                      _buildTitle('País', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _addressCountry,
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
                      _buildTitle('Estado', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _addressState,
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
                      _buildTitle('Cidade', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _addressCity,
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
                      _buildTitle('Rua', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _addressStreet,
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
                      _buildTitle('Número', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _addressNumber,
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xff6502D4), width: 2),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xff6502D4),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, {bool isRequired = true}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        if (isRequired)
          const Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF0F0F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12, 
        ),
      ),
    );
  }

  Widget _buildHalfWidthTextField({
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF0F0F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}

class CustomSizedElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomSizedElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xff6502D4)),
        ),
        backgroundColor: const Color(0xff6502D4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}