import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Usar um Container para definir o gradiente de fundo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF34016E), Color(0xFF6502D4)], // Gradiente de fundo
            begin: Alignment.centerRight, // Começa no canto superior esquerdo
            end: Alignment.centerLeft, // Termina no canto inferior direito
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding lateral
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Largura 80% da tela
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
                      Container(
                        width: double.infinity, // Largura igual ao campo de texto
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6502D4), // Cor de fundo
                            foregroundColor: Colors.white, // Cor do texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // Cantos não arredondados
                            ),
                            minimumSize: Size(double.infinity, 50), // Largura igual ao campo de texto e altura de 50
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Retorna à página anterior
                          },
                          child: Text('Cadastrar'),
                        ),
                      ),
                      SizedBox(height: 16.0), // Espaço entre o botão e o texto
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Navega para a tela anterior
                        },
                        child: Text('Voltar'),
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
