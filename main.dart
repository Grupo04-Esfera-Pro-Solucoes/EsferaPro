import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

var link = "http://localhost:8080";
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esfera Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: LoginScreen(),

    );
  }
}
