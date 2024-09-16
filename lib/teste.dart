import 'package:esferapro/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:esferapro/screens/main_screen.dart';
import './stack_pages/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color borderColor = const Color(0xFF6502D4);
  String _error = '';

  final LoginService _loginService = LoginService();

  // Método para validar o usuário
  void _validateUser(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Tenta logar usando o serviço de login
      await _loginService.login(email, password);
      
      // Se o login for bem-sucedido, navega para a tela principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      setState(() {
        // Em caso de erro, define a cor da borda como vermelha e exibe o erro
        _error = e.toString();
        borderColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 0.9;
    final double containerHeight = containerWidth * 0.4;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF34016E), Color(0xFF6502D4)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: containerWidth,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: containerWidth * 0.7,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4A0BA8),
                              Color(0xFF6502D4),
                              Color.fromARGB(255, 132, 34, 244)
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: containerWidth * 0.5,
                            height: containerHeight * 0.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 14.0,
                                color: const Color(0xFF6502D4),
                              ),
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Digite seu e-mail',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: borderColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: borderColor, width: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Senha:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 14.0,
                                color: const Color(0xFF6502D4),
                              ),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: borderColor, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: borderColor, width: 1.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0),
                      // Exibe mensagens de erro (se houver)
                      Text(_error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16.0),
                      // Botão de Login
                      SizedBox(
                        width: containerWidth * 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A0BA8),
                                Color(0xFF6502D4),
                                Color.fromARGB(255, 132, 34, 244)
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              _validateUser(context);
                            },
                            child: const Text('Entrar'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  RegisterScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const offsetBegin = Offset(1.0, 0.0);
                                const offsetEnd = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween<Offset>(begin: offsetBegin, end: offsetEnd);
                                var offsetAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));

                                return SlideTransition(position: offsetAnimation, child: child);
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Não tem uma conta? Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFF6502D4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
