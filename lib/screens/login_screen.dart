// ignore_for_file: prefer_const_constructors

import 'package:esferapro/screens/dashbord.dart';
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0), // Padding lateral
            child: Container(
              width: containerWidth, // Largura 80% da tela
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      32.0), // Padding aumentado dentro do Card
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Permite que o Card ajuste a altura
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centraliza verticalmente
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centraliza horizontalmente
                    children: [
                      Container(
                        width: containerWidth *
                            0.7, // Largura igual aos campos de texto
                        height: containerHeight, // Altura de 70% da largura
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Cor do placeholder
                          borderRadius:
                              BorderRadius.circular(8.0), // Cantos arredondados
                        ),
                        child: Center(
                          child: Icon(
                            Icons
                                .image, // Ícone de imagem para representar o logo
                            size: containerHeight *
                                0.5, // Ajusta o tamanho do ícone
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              50.0), // Espaço entre o placeholder e o campo de texto
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                      ),
                      SizedBox(height: 20.0),
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
                      SizedBox(
                          height:
                              16.0), // Adicionado espaço entre o botão e o texto
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      RegisterScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const offsetBegin = Offset(1.0,
                                    0.0); // Deslocamento inicial da direita para a esquerda
                                const offsetEnd =
                                    Offset.zero; // Deslocamento final
                                const curve =
                                    Curves.easeInOut; // Curva de animação

                                // Define a animação
                                var tween = Tween<Offset>(
                                    begin: offsetBegin, end: offsetEnd);
                                var offsetAnimation = animation.drive(
                                    tween.chain(CurveTween(curve: curve)));

                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                            ),
                          );
                        },
                        child: Text('Não tem uma conta? Cadastre-se'),
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
