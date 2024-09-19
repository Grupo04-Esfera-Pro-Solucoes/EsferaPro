import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:intl/intl.dart';
import '../model/task_model.dart';

class TaskUpdateDialog extends StatefulWidget {
  final Task task;
  final void Function(Task) onTaskUpdated;
  final void Function() onTaskDeleted;
  final int userId;

  const TaskUpdateDialog({
    required this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
    required this.userId,
    Key? key,
  }) : super(key: key);
  
  @override
  _TaskUpdateState createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdateDialog> {
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();

  bool _isDateInvalid = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.name;
    timeController.text = DateFormat('dd/MM/yyyy').format(widget.task.dueDate);
    descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Center(
        child: Text(
          "Editar Tarefa",
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
                      id: widget.task.id,
                      name: title,
                      description: description,
                      dueDate: dueDate,
                      status: widget.task.status, 
                      userId: widget.userId,
                    );

                    widget.onTaskUpdated(task);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6502D4),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Atualizar"),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              widget.onTaskDeleted();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF6502D4),
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}