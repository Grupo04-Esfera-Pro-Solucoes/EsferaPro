import 'package:esferapro/service/register_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _termsAccepted = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _postNewUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      String username = _username.text;
      String password = _password.text;
      String email = _email.text;
      String phone = _phone.text;
      String role = _role.text;

      try {
        final response = await RegisterService.postNewUser(
          username: username,
          password: password,
          email: email,
          phone: phone,
          role: role,
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
        } else {
          String responseBody = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> data = json.decode(responseBody);
          String errorMessage = data['message'] ?? 'Erro desconhecido';
          _showErrorSnackBar(errorMessage);
        }
      } catch (e) {
        _showErrorSnackBar('Erro: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 0.9;
    final double containerHeight = containerWidth * 0.4;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF34016E),
              Color(0xFF6502D4),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: containerWidth * 0.7,
                          height: containerHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A0BA8),
                                Color(0xFF6502D4),
                                Color.fromARGB(255, 132, 34, 244),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/logo.png',
                              width: containerWidth * 0.5,
                              height: containerHeight * 0.5,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _username,
                          decoration: const InputDecoration(
                            labelText: 'Nome de Usuário',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF98A2B3),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nome de usuário é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _password,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF98A2B3),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 1.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Senha é obrigatória';
                            } else if (value.length < 6) {
                              return 'A senha deve ter no mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF98A2B3),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF98A2B3),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Telefone é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _role,
                          decoration: const InputDecoration(
                            labelText: 'Cargo',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF98A2B3),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cargo é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) {
                                      return const BorderSide(
                                        color: Color.fromARGB(255, 132, 34, 244),
                                        width: 2.0,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              child: Checkbox(
                                value: _termsAccepted,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _termsAccepted = newValue ?? false;
                                  });
                                },
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'Aceito os termos de uso',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 132, 34, 244),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A0BA8),
                                Color(0xFF6502D4),
                                Color.fromARGB(255, 132, 34, 244),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: _termsAccepted ? Colors.white : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.42, 40
                              ),
                            ),
                            onPressed: _termsAccepted
                                ? () {
                                    _postNewUser();
                                  }
                                : null,
                            child: Text(
                              'Cadastrar',
                              style: TextStyle(
                                color: _termsAccepted ? Colors.white : Colors.grey, // Cor do texto cinza quando desativado
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(255, 132, 34, 244),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 132, 34, 244),
                                  width: 1.0,
                                ),
                              ),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.42, 40),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [
                                  Color(0xFF34016E),
                                  Color(0xFF4A0BA8),
                                  Color.fromARGB(255, 132, 34, 244),
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ).createShader(bounds),
                              child: const Text(
                                'Voltar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}