import 'package:flutter/material.dart';

class StackPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stack Page 2'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            child: Center(
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
