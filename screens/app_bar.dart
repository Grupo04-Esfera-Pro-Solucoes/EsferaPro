import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'configuration.dart';
import 'login.dart';

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
          iconSize: 30,
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
       const SizedBox(width: 10),
      IconButton(
        icon: const Icon(Icons.logout),
        iconSize: 30,
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
      const SizedBox(width: 10),
    ],
    toolbarHeight: 60,
  );
}