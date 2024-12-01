import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_background/flutter_background.dart';

void main() async {
  // Inicializa as permissões do Flutter Background
  WidgetsFlutterBinding.ensureInitialized();
  final hasPermissions = await FlutterBackground.hasPermissions;
  if (!hasPermissions) {
    await FlutterBackground.initialize();
  }

  await dotenv.load();
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
      decoration: const BoxDecoration(
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
        imageSize: 150,
        imageSrc: "assets/logo.png",
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
