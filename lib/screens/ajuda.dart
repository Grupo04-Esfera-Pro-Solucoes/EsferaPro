import 'package:flutter/material.dart';

class AjudaPage extends StatefulWidget {
  @override
  _AjudaPageState createState() => _AjudaPageState();
}

class _AjudaPageState extends State<AjudaPage> {
  List<bool> _expanded = List.generate(6, (_) => false);

  final List<Map<String, String>> faq = [
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
      'answer': 'Sim, vá até o icone "Perfil" na barra superior para ajustar as preferências do aplicativo.',
    },
    {
      'question': 'Quem foi a equipe responsavel pela criação do aplicativo?',
      'answer': 'Os membros da equipe são: Gustavo Dechotti, Heloisa Hartmann, Igor Costa, João Haas, Nathan Breier',
    },
  ];

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
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded[index] = !_expanded[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                            _expanded[index] ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Color(0xFF6502D4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _expanded[index] ? null : 0,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
                    ),
                    child: _expanded[index]
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              faq[index]['answer']!,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}