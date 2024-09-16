// ignore_for_file: prefer_const_constructors

import 'package:esferapro/screens/dashbord.dart';
import 'package:esferapro/screens/main_screen.dart';
import 'package:flutter/material.dart';
import './stack_pages/register_screen.dart'; // Importando a tela de cadastro
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _loginScreen();
}

class _loginScreen extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Color borderColor = Colors.purple;
  String _error = '';
  

  void _validateUser(BuildContext context) async {
    String email = _email.text;
    String password = _password.text;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('http://localhost:8080/login');

    final Map<String, dynamic> dados = {'email': email, 'password': password};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        await prefs.setInt('userId', json.decode(response.body)['idUser']);
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()), 
      );
      } else {
        print(_error);
        setState((){
          _error = json.decode(response.body)['message'];
          borderColor = Colors.red;
        });
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 0.9;
    final double containerHeight = containerWidth * 0.4; // 70% da largura

    return Scaffold(
      // Remover o backgroundColor do Scaffold
      body: Container(
        // Usar um Container para definir o gradiente de fundo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF34016E),
              Color(0xFF6502D4)
            ], // Gradiente de fundo
            begin: Alignment.centerRight, // Começa no canto superior esquerdo
            end: Alignment.centerLeft, // Termina no canto inferior direito
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: containerWidth,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
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
                              Color.fromARGB(255, 132, 34, 244)
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
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 14.0,
                                color: const Color(0xFF6502D4),
                              ),
                        ),
                      ),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: 'Digite seu e-mail',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: borderColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: borderColor, width: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Senha:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 14.0,
                                color: const Color(0xFF6502D4),
                              ),
                        ),
                      ),
                      TextField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: borderColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: borderColor, width: 1.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      Text(_error,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.5, // Largura total
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              5), // Aplicar cantos arredondados
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0xFF34016E),
                                  Color(0xFF4A0BA8),
                                  Color.fromARGB(255, 132, 34, 244)
                                ],
                                stops: const [
                                  0.0,
                                  0.5,
                                  1.0
                                ], // Ajustar a distribuição das cores
                                begin: Alignment
                                    .centerRight, // Iniciar no canto direito
                                end: Alignment
                                    .centerLeft, // Terminar no canto esquerdo
                              ),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Fundo transparente para mostrar o gradiente
                                foregroundColor: Colors.white, // Cor do texto
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Aplicar cantos arredondados
                                ),
                                minimumSize: Size(double.infinity,
                                    50), // Largura total e altura de 50
                              ),
                              onPressed: () {
                                _validateUser(context);
                              },
                              child: Text('Entrar'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  RegisterScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const offsetBegin = Offset(1.0, 0.0);
                                const offsetEnd = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween<Offset>(begin: offsetBegin, end: offsetEnd);
                                var offsetAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Não tem uma conta? Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFF6502D4),
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
    );
  }
}
