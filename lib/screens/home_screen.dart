import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Home Screen'),
      ),
      body: const Center(

        child: Text('This is the Home Screen.'),
      ),
    );
  }
}
