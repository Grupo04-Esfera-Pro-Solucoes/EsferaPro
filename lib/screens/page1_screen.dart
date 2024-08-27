import 'package:flutter/material.dart';
import 'stack_pages/stack_page1.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('This is Page 1.'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Go to Stack Page 1'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StackPage1()),
              );
            },
          ),
        ],
      ),
    );
  }
}
