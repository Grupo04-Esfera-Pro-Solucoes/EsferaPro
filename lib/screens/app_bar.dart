import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'configuration.dart';

AppBar buildAppBar(BuildContext context, String title, {String? currentRoute}) {
  return AppBar(
    centerTitle: false,
    title: Text(
      title,
      style: TextStyle(color: Color(0xFF6502D4)),
    ),
    backgroundColor: Color(0xFFEAECF0),
    iconTheme: IconThemeData(color: Color(0xFF6502D4)),
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
        icon: Icon(Icons.logout,),
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