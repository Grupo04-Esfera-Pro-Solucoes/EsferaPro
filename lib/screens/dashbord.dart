import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'drawer.dart';
import 'app_bar.dart';

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
      appBar: buildAppBar(context, _pageTitle),
      drawer: CustomDrawer(
        currentPage: _currentPage,
        onSelectPage: _selectPage,
      ),
      body: _currentPage,
    );
  }
}