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

  bool _isButtonEnabled = false;

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
    setState(() {
      _isButtonEnabled = _nomeController.text.isNotEmpty ||
                         _cargoController.text.isNotEmpty ||
                         _emailController.text.isNotEmpty ||
                         _telefoneController.text.isNotEmpty ||
                         _senhaAtualController.text.isNotEmpty ||
                         _novaSenhaController.text.isNotEmpty ||
                         _repitaNovaSenhaController.text.isNotEmpty;
    });
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://localhost:8080/user/${widget.userId}');
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
    final url = Uri.parse('http://localhost:8080/user/${widget.userId}/checkPassword');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'currentPassword': senhaAtual}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isValid'] == true;
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

        final url = Uri.parse('http://localhost:8080/user/${widget.userId}');

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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sucesso!'),
                content: const Text('Informações atualizadas com sucesso.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Erro!'),
                content: Text(json.decode(response.body)['message'] ?? 'Erro desconhecido'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro!'),
              content: const Text('Senha atual inválida.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro!'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _telefoneController,
                    labelText: 'Digite seu telefone',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _senhaAtualController,
                    labelText: 'Digite a sua senha atual',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _novaSenhaController,
                    labelText: 'Digite a nova senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _repitaNovaSenhaController,
                    labelText: 'Repita a nova senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              if (_novaSenhaController.text == _repitaNovaSenhaController.text) {
                                _updateUserInfo();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Erro!'),
                                      content: const Text('As senhas não coincidem.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 10.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF6502D4),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
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
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF98A2B3), width: 2),
        ),
        fillColor: const Color(0xFFF0F0F7),
        filled: true,
        labelStyle: const TextStyle(
          color: Color(0xFF9395C3),
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
    );
  }
}