import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallDialog extends StatelessWidget {
  final Map<String, dynamic> callData;
  final void Function(Map<String, dynamic> updatedCallData) onEdit;
  final VoidCallback onDelete;

  CallDialog({
    required this.callData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController(text: callData['description'] ?? '');
    final TextEditingController clientController = TextEditingController(text: callData['idClient']['name'] ?? '');
    final TextEditingController resultController = TextEditingController(text: callData['result']['result'] ?? '');
    final TextEditingController dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.parse(callData['date'] ?? DateTime.now().toString())));
    final TextEditingController timeController = TextEditingController(text: callData['callTime'] ?? '');
    final TextEditingController durationController = TextEditingController(text: callData['duration'] ?? '');

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
              decoration: InputDecoration(
                labelText: 'Cliente',
                labelStyle: const TextStyle(color: Color(0xFF6502D4)),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: resultController,
                    decoration: InputDecoration(
                      labelText: 'Resultado',
                      labelStyle: const TextStyle(color: Color(0xFF6502D4)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Data',
                      hintText: 'dd/MM/yyyy',
                      labelStyle: const TextStyle(color: Color(0xFF6502D4)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    decoration: InputDecoration(
                      labelText: 'Hora',
                      labelStyle: const TextStyle(color: Color(0xFF6502D4)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: durationController,
                    decoration: InputDecoration(
                      labelText: 'Duração',
                      labelStyle: const TextStyle(color: Color(0xFF6502D4)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6502D4)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: const TextStyle(color: Color(0xFF6502D4)),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6502D4)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                onPressed: () {
                  final updatedCallData = {
                    'idClient': {'name': clientController.text},
                    'result': {'result': resultController.text},
                    'description': descriptionController.text,
                    'date': DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dateController.text)),
                    'callTime': timeController.text,
                    'duration': durationController.text,
                  };
                  onEdit(updatedCallData);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF6502D4),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 40),
                ),
                child: const Text("Editar"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(width: 1, color: Colors.red),
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.white,
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}