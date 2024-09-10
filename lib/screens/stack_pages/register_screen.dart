// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _termsAccepted = false; // Variável de estado para o checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Usar um Container para definir o gradiente de fundo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF34016E),
              Color(0xFF6502D4)
            ], // Gradiente de fundo
            begin: Alignment.centerRight, // Começa no canto superior direito
            end: Alignment.centerLeft, // Termina no canto inferior esquerdo
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding lateral
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Largura 80% da tela
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0), // Padding aumentado dentro do Card
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
                    crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
                    children: [
                      Text(
                        'Cadastro',
                        style: TextStyle(
                          fontSize: 32.0, // Tamanho da fonte
                          fontWeight: FontWeight.bold, // Negrito
                          color: Colors.black, // Cor do texto
                        ),
                      ),
                      SizedBox(height: 24.0), // Espaço entre o texto e o campo de texto
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nome de Usuário',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple, width: 1.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple, width: 1.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Confirme a Senha',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple, width: 1.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 24.0),
                      // Checkbox para aceitar os termos de uso
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.purple, // Cor da borda do checkbox não selecionado
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.all(Colors.transparent), // Fundo do checkbox transparente
                                checkColor: MaterialStateProperty.all(Colors.purple), // Cor do checkmark
                                side: BorderSide(
                                  color: Colors.purple, // Cor da borda do checkbox
                                  width: 1.5,
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
                          Expanded(
                            child: Text(
                              'Aceito os termos de uso',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.purple, // Cor do texto
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0), // Espaço entre o checkbox e o botão
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,  // Largura igual ao campo de texto
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF34016E),
                              Color(0xFF4A0BA8),
                              Color.fromARGB(255, 132, 34, 244)
                            ],
                            stops: [0.0, 0.5, 1.0], // Ajustar a distribuição das cores
                            begin: Alignment.centerRight, // Iniciar no canto direito
                            end: Alignment.centerLeft, // Terminar no canto esquerdo
                          ),
                          borderRadius: BorderRadius.circular(5), // Cantos arredondados
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Deixa o fundo transparente
                            foregroundColor: Colors.white, // Cor do texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Cantos arredondados no botão
                            ),
                            minimumSize: Size(double.infinity, 50), // Aumenta a altura para 60
                          ),
                          onPressed: _termsAccepted ? () {
                            Navigator.pop(context); // Retorna à página anterior
                          } : null, // Desabilita o botão se os termos não forem aceitos
                          child: Text('Cadastrar'),
                        ),
                      ),
                      SizedBox(height: 16.0), // Espaço entre o botão e o texto
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5, // Largura 50% da tela
                        decoration: BoxDecoration(
                          color: Colors.white, // Fundo branco
                          borderRadius: BorderRadius.circular(5), // Cantos arredondados
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 4),
                            ), // Sombra
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Fundo transparente
                            shadowColor: Colors.transparent, // Remove a sombra default
                            foregroundColor: Colors.transparent, // Remove o fundo default
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Cantos arredondados
                              side: BorderSide(
                                color: Color(0xFF34016E), // Gradiente borda
                                width: 1.5,
                              ),
                            ),
                            minimumSize: Size(double.infinity, 50), // Mesma altura do botão "Cadastrar"
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Navega para a tela anterior
                          },
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Color(0xFF34016E),
                                Color(0xFF4A0BA8),
                                Color.fromARGB(255, 132, 34, 244),
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ).createShader(bounds),
                            child: Text(
                              'Voltar',
                              style: TextStyle(
                                color: Colors.white, // Cor do texto
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
    );
  }
}
