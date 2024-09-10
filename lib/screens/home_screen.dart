import 'package:flutter/material.dart';
import 'login_screen.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('This is the Home Screen.'),
      ),
    );
  }
}
