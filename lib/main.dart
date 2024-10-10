import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esfera Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF34016E),
            Color(0xFF6502D4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SplashScreenView(
        navigateRoute: LoginScreen(),
        duration: 2000,
        imageSize: 150,        // Tamanho da imagem do logo
        imageSrc: "assets/logo.png", // Caminho para a imagem do logo
        backgroundColor: Colors.transparent, // Fundo transparente para mostrar o gradiente
      ),
    );
  }
}
