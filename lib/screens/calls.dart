import 'package:flutter/material.dart';
import 'stack_pages/stack_calls.dart';

class CallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
      onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StackCalls()),
              );
            },
      backgroundColor: const Color(0xFF6502D4),
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}