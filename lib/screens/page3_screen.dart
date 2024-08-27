import 'package:flutter/material.dart';
import 'stack_pages/stack_page3.dart';

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('This is Page 3.'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Go to Stack Page 3'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StackPage3()),
              );
            },
          ),
        ],
      ),
    );
  }
}
