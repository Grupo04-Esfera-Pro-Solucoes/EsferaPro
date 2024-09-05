import 'package:flutter/material.dart';
import 'stack_pages/stack_page1.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Center(
        child: Text('This is Page 1.'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0), // Ajuste o padding conforme necessário
        child: SizedBox(
          width: 70, // Largura maior do quadrado
          height: 70, // Altura maior do quadrado
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(_createSlideTransitionRoute());
            },
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
            ),
            child: Icon(
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

  PageRouteBuilder _createSlideTransitionRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => StackPage1(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
