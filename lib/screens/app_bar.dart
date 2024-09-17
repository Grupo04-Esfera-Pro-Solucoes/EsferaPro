import 'package:flutter/material.dart';
import 'login.dart';
import 'configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppBar buildAppBar(BuildContext context, String title, {String? currentRoute}) {
  return AppBar(
    centerTitle: false,
    title: Text(
      title,
      style: const TextStyle(color: Color(0xFF6502D4)),
    ),
    backgroundColor: const Color(0xFFEAECF0),
    iconTheme: const IconThemeData(color: Color(0xFF6502D4)),
    actions: [
      if (currentRoute != '/configuration')
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            int? userId = prefs.getInt('userId');

            if (userId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigurationPage(userId: userId),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
        ),
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('userId');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      ),
    ],
    toolbarHeight: 60,
  );
}