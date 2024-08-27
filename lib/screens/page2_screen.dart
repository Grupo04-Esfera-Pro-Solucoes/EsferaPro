import 'package:flutter/material.dart';
import 'stack_pages/stack_page2.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('This is Page 2.'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Go to Stack Page 2'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StackPage2()),
              );
            },
          ),
        ],
      ),
    );
  }
}
