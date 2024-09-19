import 'package:flutter/material.dart';

class StackClients extends StatefulWidget {
  @override
  _StackClientsState createState() => _StackClientsState();
}

class _StackClientsState extends State<StackClients> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _repitaNovaSenhaController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cargoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _repitaNovaSenhaController.dispose();
    super.dispose();
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
                      controller: _nomeController,
                      hintText: 'Nome do cliente',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('CPF ou CNPJ'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _nomeController,
                      hintText: 'CPF/CNPJ',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('Empresa'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _nomeController,
                      hintText: 'Nome da empresa',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('Cargo'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _nomeController,
                      hintText: 'Cargo do cliente',
                    ),
                    const SizedBox(height: 10),
                    _buildTitle('Data de Nascimento'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: _nomeController,
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
                      controller: _nomeController,
                      hintText: 'exemplo@email.com',
                    ),
                    const SizedBox(height: 20),
                    _buildTitle('Contato'),
                    const SizedBox(height: 5),
                    _buildTextField(
                        controller: _nomeController,
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
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('CEP'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _telefoneController,
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
                              controller: _telefoneController,
                              hintText: 'Brasil',
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Estado'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _telefoneController,
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
                              controller: _telefoneController,
                              hintText: 'Cidade x',
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Rua'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _telefoneController,
                              hintText: 'Rua x',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('Número'),
                            const SizedBox(height: 8),
                            _buildHalfWidthTextField(
                              controller: _telefoneController,
                              hintText: '00',
                            ),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CustomElevatedButton(
                          onPressed: () {
                            // Ação para o botão "Salvar"
                          },
                          text: 'Salvar',
                        ),
                      ],
                    ),
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


class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomElevatedButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
    );
  }
}