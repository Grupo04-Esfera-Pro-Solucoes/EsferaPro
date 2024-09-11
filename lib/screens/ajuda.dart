import 'package:flutter/material.dart';

class AjudaPage extends StatefulWidget {
  @override
  _AjudaPageState createState() => _AjudaPageState();
}

class _AjudaPageState extends State<AjudaPage> {

  final List<bool> _expandedStates = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faq.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF98A2B3), width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedStates[index] = !_expandedStates[index];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                faq[index]['question']!,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6502D4),
                                ),
                              ),
                            ),
                            Icon(
                              _expandedStates[index]
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Color(0xFF6502D4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_expandedStates[index])
                      Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          faq[index]['answer']!,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final List<Map<String, String>> faq = [
    {
      'question': 'Qual o melhor sistema CRM?',
      'answer': 'É o EsferaPro Soluções!',
    },
    {
      'question': 'Esqueci minha senha, o que faço?',
      'answer': 'Clique em "Esqueceu a senha?" na tela de login e siga as instruções para redefinir sua senha.',
    },
    {
      'question': 'Como faço para adicionar um novo cliente?',
      'answer': 'Vá até a tela "Clientes" e clique no botão de adicionar para inserir um novo cliente.',
    },
    {
      'question': 'Como vejo minhas propostas?',
      'answer': 'Vá até a aba "Propostas" no menu lateral para acessar todas as suas propostas.',
    },
    {
      'question': 'Como faço para realizar uma ligação?',
      'answer': 'Na aba "Ligações", você pode acessar a lista de contatos e realizar chamadas diretamente.',
    },
    {
      'question': 'Posso alterar as configurações do aplicativo?',
      'answer': 'Sim, vá até a aba "Configurações" no menu lateral para ajustar as preferências do aplicativo.',
    },
    {
      'question': 'Qual a equipe responsavel pelo projeto?',
      'answer': 'Gustavo Dechotti, Heloisa Hartmann, Igor Costa, João Hass, Nathan Breier',
    },
  ];
}