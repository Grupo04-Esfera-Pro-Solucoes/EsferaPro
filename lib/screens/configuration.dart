import 'package:flutter/material.dart';
import 'app_bar.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _repitaNovaSenhaController = TextEditingController();

  bool _isButtonEnabled = false;

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _nomeController.text.isNotEmpty ||
                         _sobrenomeController.text.isNotEmpty ||
                         _cargoController.text.isNotEmpty ||
                         _emailController.text.isNotEmpty ||
                         _telefoneController.text.isNotEmpty ||
                         _senhaAtualController.text.isNotEmpty ||
                         _novaSenhaController.text.isNotEmpty ||
                         _repitaNovaSenhaController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(_checkFields);
    _sobrenomeController.addListener(_checkFields);
    _cargoController.addListener(_checkFields);
    _emailController.addListener(_checkFields);
    _telefoneController.addListener(_checkFields);
    _senhaAtualController.addListener(_checkFields);
    _novaSenhaController.addListener(_checkFields);
    _repitaNovaSenhaController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
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
      appBar: buildAppBar(context, 'Configurações', currentRoute: '/configuration'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF6502D4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Atualize suas informações.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            final nome = _nomeController.text;
                            final sobrenome = _sobrenomeController.text;
                            final cargo = _cargoController.text;
                            final email = _emailController.text;
                            final telefone = _telefoneController.text;
                            final senhaAtual = _senhaAtualController.text;
                            final novaSenha = _novaSenhaController.text;
                            final repitaNovaSenha = _repitaNovaSenhaController.text;
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFF6502D4),
                      side: BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
                      elevation: 0,
                    ).copyWith(
                      elevation: MaterialStateProperty.resolveWith<double>(
                        (states) => states.contains(MaterialState.disabled)
                            ? 0 : 20,
                      ),
                    ),
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Esse nome será exibido no seu perfil.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _nomeController,
                    labelText: 'Digite seu nome',
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _sobrenomeController,
                    labelText: 'Digite seu sobrenome',
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Cargo',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Essa é a sua função dentro da empresa.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _cargoController,
                    labelText: 'Digite o seu cargo',
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Esse e-mail será usado para fazer o login.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Digite o seu email',
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Telefone',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _telefoneController,
                    labelText: 'Digite seu telefone',
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _senhaAtualController,
                    labelText: 'Digite a sua senha atual',
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _novaSenhaController,
                    labelText: 'Digite a nova senha',
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _repitaNovaSenhaController,
                    labelText: 'Repita a nova senha',
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF98A2B3), width: 2),
        ),
        fillColor: Color(0xFFF0F0F7),
        filled: true,
        labelStyle: TextStyle(
          color: Color(0xFF9395C3),
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
        ),
      ),
    );
  }
}