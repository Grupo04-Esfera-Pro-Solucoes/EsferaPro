import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/call_service.dart';

class StackCalls extends StatefulWidget {
  @override
  _StackCallsState createState() => _StackCallsState();
}

class _StackCallsState extends State<StackCalls> {
  final TextEditingController _clientName = TextEditingController();
  final TextEditingController _callResult = TextEditingController();
  final TextEditingController _clientCpfCnpj = TextEditingController();
  final TextEditingController _callDuration = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _callDate = TextEditingController();
  final TextEditingController _callTime = TextEditingController();
  final TextEditingController _callDescription = TextEditingController();

  final CallService _CallService = CallService();

  void _postNewCall() {
    _CallService.postNewCall(
      name: _clientName.text,
      cpfCnpj:  _clientCpfCnpj.text,
      result: _callResult.text,
      duration: _callDuration.text,
      contactNumber: _contactNumber.text,
      date: _callDate.text,
      time: _callTime .text,
      description: _callDescription.text,
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
                      _buildTitle('CPF ou CNPJ'),
                      const SizedBox(height: 5),
                      _buildTextField(
                        maxLines: 1,
                        controller: _clientCpfCnpj,
                        hintText: '123.456.789-00',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Selecione o Cliente', isRequired: true),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _clientName,
                        hintText: '',
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _buildTitle('Resultado'),
              const SizedBox(height: 5),
              _buildTextField(
                maxLines: 1,
                controller: _callResult,
                hintText: 'Escolha o Resultado',
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Duração da ligação', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _callDuration,
                        hintText: '--:--',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Contato', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _contactNumber,
                        hintText: '99 999999999',
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
                      _buildTitle('Data da Ligação', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _callDate,
                        hintText: '00/00/0000',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Horário da Ligação', isRequired: false),
                      const SizedBox(height: 5),
                      _buildHalfWidthTextField(
                        controller: _callTime,
                        hintText: '00:00',
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 15),
              const Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _callDescription,
                maxLines: 7,
                hintText: 'Informações da ligação',
              ),
              const SizedBox(height: 30),
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
                        _postNewCall();
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
    List<TextInputFormatter>? inputFormatters, required int maxLines,
  }) {
    return TextField(
      controller: controller,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 16),
      maxLines: maxLines,
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