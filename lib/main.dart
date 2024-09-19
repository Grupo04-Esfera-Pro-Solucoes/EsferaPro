import 'package:flutter/material.dart';
import './screens/login_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esfera Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const LoginScreen(),

    );
  }
}
