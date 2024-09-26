import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class ProposalCadastro extends StatefulWidget {
  @override
  _ProposalCadastroState createState() => _ProposalCadastroState();
}

class _ProposalCadastroState extends State<ProposalCadastro> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _postNewProposal() async {
    if (_formKey.currentState?.validate() ?? false) {
      String title = _titleController.text;
      String description = _descriptionController.text;
      String value = _valueController.text;
      String date = _dateController.text;
      String id = _idController.text;
      String clientId = _clientIdController.text;
      String clientName = _clientNameController.text;

      try {
        // Simulação de envio de proposta
        final response = await Future.delayed(
          Duration(seconds: 2),
          () => {'statusCode': 200},
        );

        if (response['statusCode'] == 200) {
          Navigator.pop(context);
        } else {
          _showErrorSnackBar('Erro ao enviar proposta');
        }
      } catch (e) {
        _showErrorSnackBar('Erro: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9393C2)),
      ),
      fillColor: Color(0xFFF0F0F7),
      filled: true,
      labelStyle: TextStyle(color: Color(0xFF9393C2)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9393C2)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.description, color: Color(0xFFF7BD2E)), // Icon updated here
            SizedBox(width: 8.0), // Space between icon and text
            Text(
              'Cadastro de Propostas',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color(0xFF6502D4),
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          Container(
            height: 10,
            color: Color(0xFF6502D4),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'Informações Gerais',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _idController,
                              decoration: inputDecoration.copyWith(
                                labelText: 'ID da Ligação',
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ID é obrigatório';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _dateController,
                              decoration: inputDecoration._selectDate(
                                labelText: 'Data de Conclusão',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF9393C2),
                                  ),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Data de Conclusão é obrigatória';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _valueController,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Valor da Proposta',
                          prefixText: 'R\$ ',
                        ),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Valor da Proposta é obrigatório';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Por favor, insira um valor válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _clientIdController,
                              decoration: inputDecoration.copyWith(
                                labelText: 'ID do Cliente',
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ID do Cliente é obrigatório';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _clientNameController,
                              decoration: inputDecoration.copyWith(
                                labelText: 'Nome do Cliente',
                              ),
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nome do Cliente é obrigatório';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32.0),
                      const Center(
                        child: Text(
                          'Anexo de Arquivo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Implementar a lógica de anexar arquivos
                          },
                          child: Container(
                            width: 250.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF475467)),
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.attach_file,
                                  color: Color(0xFF475467),
                                  size: 30.0,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Clique aqui para anexar um arquivo',
                                  style: TextStyle(
                                    color: Color(0xFF475467),
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      const Center(
                        child: Text(
                          'Descrição da Tarefa',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: inputDecoration.copyWith(
                          labelText: 'Descrição da Tarefa',
                        ),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Descrição é obrigatória';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Color(0xFF475467)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFF475467)),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 140,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _postNewProposal,
                              child: const Text(
                                'Salvar',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6502D4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
