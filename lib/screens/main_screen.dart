import 'package:flutter/material.dart';
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

  void _selectPage(Widget page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' '),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _selectPage(HomeScreen());
              },
            ),
            ListTile(
              title: Text('Page 1'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _selectPage(Page1());
              },
            ),
            ListTile(
              title: Text('Page 2'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _selectPage(Page2());
              },
            ),
            ListTile(
              title: Text('Page 3'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _selectPage(Page3());
              },
            ),
            ListTile(
              title: Text('Page 4'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _selectPage(Page4());
              },
            ),
          ],
        ),
      ),
      body: _currentPage,
    );
  }
}

