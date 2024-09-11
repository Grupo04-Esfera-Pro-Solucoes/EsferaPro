import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentPage = HomeScreen();
  String _pageTitle = 'Dashboard';

  void _selectPage(Widget page, String title) {
    setState(() {
      _currentPage = page;
      _pageTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _pageTitle,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6502D4),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
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
      drawer: CustomDrawer(
        currentPage: _currentPage,
        onSelectPage: _selectPage,
      ),
      body: _currentPage,
    );
  }
}
