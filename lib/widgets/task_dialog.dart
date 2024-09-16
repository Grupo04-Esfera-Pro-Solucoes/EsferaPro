import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task_model.dart';

class AddTaskDialog extends StatelessWidget {
  final void Function(Task) onTaskCreated;
  final int userId;

  AddTaskDialog({required this.onTaskCreated, required this.userId}) {
    print('AddTaskDialog inicializado com userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final descriptionController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Center(
        child: Text(
          "Adicionar Tarefa",
          style: TextStyle(
            color: Color(0xFF6502D4),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vencimento:",
                        style: TextStyle(color: Color(0xFF6502D4), fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          hintText: "dd/MM/yyyy",
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tarefa:",
                      style: TextStyle(color: Color(0xFF6502D4), fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Título",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Descrição:",
            style: TextStyle(color: Color(0xFF6502D4), fontSize: 14),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: "Escreva uma descrição",
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
      actions: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(width: 1, color: Color(0xFF6502D4)),
                  ),
                  child: const Text("Cancelar", style: TextStyle(color: Color(0xFF6502D4))),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();
                    final dueDateStr = timeController.text.trim();

                    if (title.isNotEmpty && description.isNotEmpty && dueDateStr.isNotEmpty) {
                      try {
                        final dueDate = DateFormat('dd/MM/yyyy').parseStrict(dueDateStr);

                        final task = Task(
                          id: 0,
                          name: title,
                          description: description,
                          dueDate: dueDate,
                          status: "todo",
                          userId: userId,
                        );

                        print('Criando tarefa com userId: $userId');

                        onTaskCreated(task);
                        Navigator.pop(context);
                        _showMessageDialog(context, 'Sucesso', 'Tarefa criada com sucesso!');
                      } catch (e) {
                        _showErrorDialog(context, 'Data inválida', 'Por favor, insira a data no formato dd/MM/yyyy.');
                      }
                    } else {
                      _showErrorDialog(context, 'Campos obrigatórios', 'Todos os campos devem ser preenchidos.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6502D4),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Adicionar"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMessageDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}