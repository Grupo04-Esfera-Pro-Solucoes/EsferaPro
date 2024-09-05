import 'package:flutter/material.dart';

class StackPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stack Page 3'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            child: Center(
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
