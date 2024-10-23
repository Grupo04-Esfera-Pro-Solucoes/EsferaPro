import 'package:flutter/material.dart';
import 'stack_pages/stack_page1.dart';


class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(
        child: Text('This is Page 1.'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0), // Ajuste o padding conforme necessário
        child: SizedBox(
          width: 70, // Largura maior do quadrado
          height: 70, // Altura maior do quadrado
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StackPage1()),
              );
            },
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
            ),
            child: const Icon(
              Icons.add,
              size: 40, // Tamanho maior do ícone
              color: Colors.white, // Cor do + branco
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
