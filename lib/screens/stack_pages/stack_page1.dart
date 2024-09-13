import 'package:flutter/material.dart';

class StackPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack Page 1'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            child: const Center(
              child: Text(
                'This is Stack Page 1',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
