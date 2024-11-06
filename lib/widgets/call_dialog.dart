import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallDialog extends StatefulWidget {
  final Map<String, dynamic> callData;
  final Future<void> Function(Map<String, dynamic> updatedCallData) onEdit;
  final VoidCallback onDelete;

  const CallDialog({
    required this.callData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _CallDialogState createState() => _CallDialogState();
}

class _CallDialogState extends State<CallDialog> {
  late TextEditingController descriptionController;
  late TextEditingController clientController;
  late TextEditingController resultController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController durationController;
  late TextEditingController contactController;

  int selectedResultId = 1;  // Default to 'Atendido' with ID 1

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController(text: widget.callData['description'] ?? '');
    clientController = TextEditingController(text: widget.callData['idClient']['name'] ?? '');
    resultController = TextEditingController(text: widget.callData['result']['result'] ?? '');
    dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.callData['date'] ?? DateTime.now().toString())));
    timeController = TextEditingController(text: widget.callData['callTime'] ?? '');
    durationController = TextEditingController(text: widget.callData['duration'] ?? '');
    contactController = TextEditingController(text: widget.callData['contact'] ?? '');

    // Setting the initial selected result ID based on the passed data
    selectedResultId = widget.callData['result']['idLeadResult'] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Center(
        child: Text(
          "Editar Lead",
          style: TextStyle(
            color: Color(0xFF6502D4),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: clientController,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                labelStyle: TextStyle(color: Color(0xFF6502D4)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contato',
                labelStyle: TextStyle(color: Color(0xFF6502D4)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            // Dropdown for selecting result
            DropdownButtonFormField<int>(
              value: selectedResultId,
              decoration: const InputDecoration(
                labelText: 'Resultado',
                labelStyle: TextStyle(color: Color(0xFF6502D4)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Atendido')),
                DropdownMenuItem(value: 2, child: Text('Desligado')),
                DropdownMenuItem(value: 3, child: Text('Cx. Postal')),
                DropdownMenuItem(value: 4, child: Text('Ocupado')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedResultId = value ?? 1;  // Default to 1 if null
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      hintText: 'dd/MM/yyyy',
                      labelStyle: TextStyle(color: Color(0xFF6502D4)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Hora',
                      labelStyle: TextStyle(color: Color(0xFF6502D4)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duração',
                      labelStyle: TextStyle(color: Color(0xFF6502D4)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: Color(0xFF6502D4)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 1, color: Color(0xFF6502D4)),
                  minimumSize: const Size(80, 40),
                ),
                child: const Text("Cancelar", style: TextStyle(color: Color(0xFF6502D4))),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  try {
                    final updatedCallData = {
                      'contact': contactController.text,
                      'date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateFormat('dd/MM/yyyy').parse(dateController.text)),
                      'duration': durationController.text,
                      'description': descriptionController.text,
                      'result': {
                        'idLeadResult': selectedResultId,
                      },
                      'callTime': timeController.text,
                    };
                    print("Dados enviados para atualização: $updatedCallData");

                    await widget.onEdit(updatedCallData); 
                    Navigator.pop(context);
                  } catch (e) {
                    print("Erro ao salvar: $e");
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF6502D4),
                  minimumSize: const Size(80, 40),
                ),
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}