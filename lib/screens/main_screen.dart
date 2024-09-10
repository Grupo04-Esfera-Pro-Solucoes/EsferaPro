import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'page1_screen.dart';
import 'page2_screen.dart';
import 'page3_screen.dart';
import 'page4_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentPage = HomeScreen();
  int _selectedPageIndex = 0; // Índice da página selecionada

  // Função para obter o título com base na página atual
  String _getPageTitle() {
    if (_currentPage is HomeScreen) return 'Home';
    if (_currentPage is ClientPage) return 'Page 1';
    if (_currentPage is Page2) return 'Page 2';
    if (_currentPage is Page3) return 'Page 3';
    if (_currentPage is Page4) return 'Page 4';
    return '';
  }

  void _selectPage(Widget page, int index) {
    setState(() {
      _currentPage = page;
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centraliza o título
        title: Text(
          _getPageTitle(),
          style: TextStyle(color: Colors.white),
        ), // Exibe o título dinâmico
        backgroundColor: Color(0xFF6502D4), // Define a cor roxa para a AppBar
        iconTheme: IconThemeData(
            color: Colors.white), // Define a cor do ícone do drawer
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Ação ao clicar no avatar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Avatar clicked')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6502D4), // Cor roxa para o cabeçalho do Drawer
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              tileColor: _selectedPageIndex == 0
                  ? Color(0xFF6502D4).withOpacity(0.1)
                  : null, // Destaca a página atual
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                _selectPage(HomeScreen(), 0);
              },
            ),
            ListTile(
              title: Text('Page 1'),
              tileColor: _selectedPageIndex == 1
                  ? Color(0xFF6502D4).withOpacity(0.1)
                  : null, // Destaca a página atual
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                _selectPage(ClientPage(), 1);
              },
            ),
            ListTile(
              title: Text('Page 2'),
              tileColor: _selectedPageIndex == 2
                  ? Color(0xFF6502D4).withOpacity(0.1)
                  : null, // Destaca a página atual
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                _selectPage(Page2(), 2);
              },
            ),
            ListTile(
              title: Text('Page 3'),
              tileColor: _selectedPageIndex == 3
                  ? Color(0xFF6502D4).withOpacity(0.1)
                  : null, // Destaca a página atual
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                _selectPage(Page3(), 3);
              },
            ),
            ListTile(
              title: Text('Page 4'),
              tileColor: _selectedPageIndex == 4
                  ? Color(0xFF6502D4).withOpacity(0.1)
                  : null, // Destaca a página atual
              onTap: () {
                Navigator.of(context).pop(); // Fecha o drawer
                _selectPage(Page4(), 4);
              },
            ),
          ],
        ),
      ),
      body: _currentPage,
    );
  }
}
