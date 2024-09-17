import 'package:flutter/material.dart';

class StackClients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack Page 2'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            child: const Center(
              child: Text(

                'This is Stack Page 2',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
