import 'package:flutter/material.dart';
import 'stack_pages/stack_page4.dart';

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 4'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('This is Page 4.'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Go to Stack Page 4'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StackPage4()),
              );
            },
          ),
        ],
      ),
    );
  }
}
