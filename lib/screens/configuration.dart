import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_bar.dart';

class ConfigurationPage extends StatefulWidget {
  final int userId;

  const ConfigurationPage({required this.userId});

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaAtualController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _repitaNovaSenhaController = TextEditingController();

  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureRepitaNovaSenha = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();

    _nomeController.addListener(_checkFields);
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
    _cargoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _repitaNovaSenhaController.dispose();
    super.dispose();
  }

  void _checkFields() {
    setState(() {});
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://grupo04.duckdns.org:8080/user/${widget.userId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        setState(() {
          _nomeController.text = data['name'] ?? '';
          _cargoController.text = data['role'] ?? '';
          _emailController.text = data['email'] ?? '';
          _telefoneController.text = data['phone'] ?? '';
        });
      } else {
        print('Erro ao buscar os dados do usuário.');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<bool> _validateCurrentPassword() async {
    final senhaAtual = _senhaAtualController.text;
    final url = Uri.parse('http://grupo04.duckdns.org:8080/user/${widget.userId}/checkPassword?currentPassword=$senhaAtual');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data == true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }

  void _updateUserInfo() async {
    try {
      final validPassword = await _validateCurrentPassword();

      if (validPassword) {
        final nome = _nomeController.text;
        final cargo = _cargoController.text;
        final email = _emailController.text;
        final telefone = _telefoneController.text;
        final novaSenha = _novaSenhaController.text;

        final url = Uri.parse('http://grupo04.duckdns.org:8080/user/${widget.userId}');

        final Map<String, dynamic> dados = {
          'name': nome,
          'email': email,
          'phone': telefone,
          'role': cargo,
          'passwordHash': novaSenha.isNotEmpty ? novaSenha : null,
        };

        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dados),
        );

        if (response.statusCode == 200) {
          _showCustomDialog(
            title: 'Sucesso!',
            content: 'Informações atualizadas com sucesso.',
            isSuccess: true,
          );

          _senhaAtualController.clear();
          _novaSenhaController.clear();
          _repitaNovaSenhaController.clear();
        } else {
          _showCustomDialog(
            title: 'Erro!',
            content: json.decode(response.body)['message'] ?? 'Erro desconhecido',
            isSuccess: false,
          );
        }
      } else {
        _showCustomDialog(
          title: 'Erro!',
          content: 'Senha atual inválida.',
          isSuccess: false,
        );
      }
    } catch (e) {
      _showCustomDialog(
        title: 'Erro!',
        content: e.toString(),
        isSuccess: false,
      );
    }
  }

  void _showCustomDialog({
    required String title,
    required String content,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6502D4),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'OK',
              ),
            ],
          ),
        );
      },
    );
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
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF6502D4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Atualize suas informações.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nome',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Esse nome será exibido no seu perfil.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nomeController,
                    labelText: 'Digite seu nome',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cargo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Essa é a sua função dentro da empresa.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _cargoController,
                    labelText: 'Digite o seu cargo',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Esse e-mail será usado para fazer o login.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Digite o seu email',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Telefone',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _telefoneController,
                    labelText: 'Digite seu telefone',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Senha Atual',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildPasswordField(
                    controller: _senhaAtualController,
                    labelText: 'Digite a sua senha atual',
                    obscureText: _obscureSenhaAtual,
                    onVisibilityChanged: () {
                      setState(() {
                        _obscureSenhaAtual = !_obscureSenhaAtual;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nova Senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildPasswordField(
                    controller: _novaSenhaController,
                    labelText: 'Digite a nova senha',
                    obscureText: _obscureNovaSenha,
                    onVisibilityChanged: () {
                      setState(() {
                        _obscureNovaSenha = !_obscureNovaSenha;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _repitaNovaSenhaController,
                    labelText: 'Repita a nova senha',
                    obscureText: _obscureRepitaNovaSenha,
                    onVisibilityChanged: () {
                      setState(() {
                        _obscureRepitaNovaSenha = !_obscureRepitaNovaSenha;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        if (_novaSenhaController.text == _repitaNovaSenhaController.text) {
                          _updateUserInfo();
                        } else {
                          _showCustomDialog(
                            title: 'Erro!',
                            content: 'As senhas não coincidem.',
                            isSuccess: false,
                          );
                        }
                      },
                      text: 'Salvar',
                    ),
                  )
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
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF98A2B3), width: 2),
        ),
        fillColor: const Color(0xFFF0F0F7),
        filled: true,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onVisibilityChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF98A2B3), width: 2),
        ),
        fillColor: const Color(0xFFF0F0F7),
        filled: true,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF6502D4),
            ),
            onPressed: onVisibilityChanged,
          ),
        ),
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