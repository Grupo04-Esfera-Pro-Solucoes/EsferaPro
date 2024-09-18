import 'package:flutter/material.dart';

class StackClients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo da página (pode ser uma imagem, cor, etc.)

          // Conteúdo da página
          SingleChildScrollView(
            
              child: Column(
                children: [
                  SizedBox(height: 60), // Espaço do topo da página
                  // Cabeçalho
                  Text(
                    'Cadastro de Cliente',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30), // Espaço entre o cabeçalho e o formulário
                  // Formulário
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 8.0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Campo Nome
                          Text(
                            'Nome',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
    
                            decoration: InputDecoration(
                              hintText: 'Digite seu nome',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o nome';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Campo Email
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
            
                            decoration: InputDecoration(
                              hintText: 'Digite seu email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Insira um email válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Campo Telefone
                          Text(
                            'Telefone',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                          
                            decoration: InputDecoration(
                              hintText: 'Digite seu telefone',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o telefone';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Botão de Envio
                          ElevatedButton(
                            onPressed: () {
                              // Lógica para processar os dados do cliente
                              

                              // Exemplo: imprimir no console
                              

                              // Pode salvar os dados no banco de dados, chamar uma API, etc.

                              // Limpar os campos após o cadastro
                              
                            },
                            child: Text('Cadastrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
        ],
      ),
    );
  }
}
