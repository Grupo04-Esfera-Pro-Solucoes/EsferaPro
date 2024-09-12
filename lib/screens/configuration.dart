import 'package:flutter/material.dart';
import 'app_bar.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();

  bool _isButtonEnabled = false;

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _nomeController.text.isNotEmpty && _sobrenomeController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(_checkFields);
    _sobrenomeController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Configurações', currentRoute: '/configuration'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Informações Pessoais',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            final nome = _nomeController.text;
                            final sobrenome = _sobrenomeController.text;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Informações salvas!'),
                            ));
                          }
                        : null,
                    child: Text('Salvar'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Digite o seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _sobrenomeController,
              decoration: InputDecoration(
                labelText: 'Digite o seu sobrenome',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}