import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../model/task_model.dart';

class AddTaskDialog extends StatefulWidget {
  final void Function(Task) onTaskCreated;
  final int userId;

  const AddTaskDialog({required this.onTaskCreated, required this.userId});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();

  bool _isDateInvalid = false;

  @override
  Widget build(BuildContext context) {
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
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskedInputFormatter('00/00/0000'),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isDateInvalid = false;
                          });
                        },
                      ),
                      if (_isDateInvalid)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Formato de data inválido",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
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

                    DateTime? dueDate;
                    try {
                      dueDate = DateFormat('dd/MM/yyyy').parseStrict(dueDateStr);
                    } catch (e) {
                      setState(() {
                        _isDateInvalid = true;
                      });
                      return;
                    }
                    final task = Task(
                      id: 0,
                      name: title,
                      description: description,
                      dueDate: dueDate,
                      status: "todo",
                      userId: widget.userId,
                    );

                    widget.onTaskCreated(task);
                    Navigator.pop(context);
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
}