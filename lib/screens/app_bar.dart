import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'configuration.dart';

AppBar buildAppBar(BuildContext context, String title, {String? currentRoute}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color(0xFF6502D4),
    iconTheme: IconThemeData(color: Colors.white),
    actions: [
      if (currentRoute != '/configuration')
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfigurationPage()),
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
  );
}