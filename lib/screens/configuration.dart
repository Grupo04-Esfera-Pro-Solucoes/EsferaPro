import '../service/configuration_service.dart';
import 'package:flutter/material.dart';
import 'app_bar.dart';

class ConfigurationPage extends StatefulWidget {
  final int userId;

  const ConfigurationPage({required this.userId, Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final _nomeController = TextEditingController();
  final _cargoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _repitaNovaSenhaController = TextEditingController();

  bool _obscureSenhaAtual = true;
  bool _obscureNovaSenha = true;
  bool _obscureRepitaNovaSenha = true;

  final ConfigurationService _configurationService = ConfigurationService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();

    [_nomeController, _cargoController, _emailController, _telefoneController, _senhaAtualController, _novaSenhaController, _repitaNovaSenhaController]
        .forEach((controller) => controller.addListener(_checkFields));
  }

  @override
  void dispose() {
    [_nomeController, _cargoController, _emailController, _telefoneController, _senhaAtualController, _novaSenhaController, _repitaNovaSenhaController]
        .forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _configurationService.fetchUserData(widget.userId);
      if (userData != null) {
        setState(() {
          _nomeController.text = userData['name'] ?? '';
          _cargoController.text = userData['role'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _telefoneController.text = userData['phone'] ?? '';
        });
      } else {
        _showCustomDialog(
          title: 'Erro',
          content: 'Não foi possível carregar os dados do usuário.',
          isSuccess: false,
        );
      }
    } catch (e) {
      _showCustomDialog(
        title: 'Erro',
        content: 'Falha ao carregar os dados do usuário: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> _updateUserInfo() async {
    if (_novaSenhaController.text != _repitaNovaSenhaController.text) {
      _showCustomDialog(
        title: 'Erro!',
        content: 'As senhas não coincidem.',
        isSuccess: false,
      );
      return;
    }

    try {
      final isPasswordValid = await _configurationService.validateCurrentPassword(
        widget.userId,
        _senhaAtualController.text,
      );

      if (!isPasswordValid) {
        _showCustomDialog(
          title: 'Erro',
          content: 'A senha atual está incorreta.',
          isSuccess: false,
        );
        return;
      }

      final success = await _configurationService.updateUserInfo(
        userId: widget.userId,
        name: _nomeController.text,
        role: _cargoController.text,
        email: _emailController.text,
        phone: _telefoneController.text,
        newPassword: _novaSenhaController.text.isNotEmpty ? _novaSenhaController.text : null,
      );

      if (success) {
        _showCustomDialog(
          title: 'Sucesso',
          content: 'As informações foram atualizadas com sucesso.',
          isSuccess: true,
        );
      } else {
        _showCustomDialog(
          title: 'Erro',
          content: 'Houve um problema ao atualizar as informações.',
          isSuccess: false,
        );
      }
    } catch (e) {
      _showCustomDialog(
        title: 'Erro',
        content: 'Falha ao atualizar as informações: $e',
        isSuccess: false,
      );
    }
  }

  void _checkFields() {
    setState(() {});
  }

  void _showCustomDialog({
    required String title,
    required String content,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6502D4),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'OK',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Configurações', currentRoute: '/configuration'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF6502D4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Atualize suas informações.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nome',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Esse nome será exibido no seu perfil.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nomeController,
                    labelText: 'Digite seu nome',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cargo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Essa é a sua função dentro da empresa.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _cargoController,
                    labelText: 'Digite o seu cargo',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Esse e-mail será usado para fazer o login.',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Digite o seu email',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Telefone',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _telefoneController,
                    labelText: 'Digite seu telefone',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Senha Atual',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildPasswordField(
                    controller: _senhaAtualController,
                    labelText: 'Digite a sua senha atual',
                    obscureText: _obscureSenhaAtual,
                    onVisibilityChanged: () {
                      setState(() {
                        _obscureSenhaAtual = !_obscureSenhaAtual;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nova Senha',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildPasswordField(
                    controller: _novaSenhaController,
                    labelText: 'Digite a nova senha',
                    obscureText: _obscureNovaSenha,
                    onVisibilityChanged: () {
                      setState(() {
                        _obscureNovaSenha = !_obscureNovaSenha;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    controller: _repitaNovaSenhaController,
                    labelText: 'Repita a nova senha',
                    obscureText: _obscureRepitaNovaSenha,
                    onVisibilityChanged: () {
                      setState(() {
                        _obscureRepitaNovaSenha = !_obscureRepitaNovaSenha;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () {
                        if (_novaSenhaController.text == _repitaNovaSenhaController.text) {
                          _updateUserInfo();
                        } else {
                          _showCustomDialog(
                            title: 'Erro!',
                            content: 'As senhas não coincidem.',
                            isSuccess: false,
                          );
                        }
                      },
                      text: 'Salvar',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF98A2B3), width: 2),
        ),
        fillColor: const Color(0xFFF0F0F7),
        filled: true,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onVisibilityChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF98A2B3), width: 2),
        ),
        fillColor: const Color(0xFFF0F0F7),
        filled: true,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF6502D4),
            ),
            onPressed: onVisibilityChanged,
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomElevatedButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color(0xFF6502D4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}