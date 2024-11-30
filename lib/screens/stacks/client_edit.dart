import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ClientEdit extends StatefulWidget {
  final Map<String, dynamic> clientData;
  final Future<void> Function(Map<String, dynamic> updatedClientData) onEdit;
  final Future<void> Function(String) onDelete;

  const ClientEdit({
    required this.clientData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _ClientEditState createState() => _ClientEditState();
}

class _ClientEditState extends State<ClientEdit> {
  late TextEditingController descriptionController;
  late TextEditingController clientController;
  late TextEditingController resultController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController durationController;
  late TextEditingController contactController;

  int selectedResultId = 1;

  @override
  void initState() {
    super.initState();

    descriptionController =
        TextEditingController(text: widget.clientData['description'] ?? '');
    clientController =
        TextEditingController(text: widget.clientData['idClient']['name'] ?? '');
    resultController =
        TextEditingController(text: widget.clientData['result']['result'] ?? '');
    dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.parse(
            widget.clientData['date'] ?? DateTime.now().toString())));
    timeController =
        TextEditingController(text: widget.clientData['clientTime'] ?? '');
    durationController =
        TextEditingController(text: widget.clientData['duration'] ?? '');
    contactController =
        TextEditingController(text: widget.clientData['contact'] ?? '');

    selectedResultId = widget.clientData['result']['idLeadResult'] ?? 1;
  }

  Widget _buildTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    required bool readOnly,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        readOnly: readOnly,
      ),
    );
  }

  Widget _buildHalfWidthTextField({
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    required bool readOnly,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        readOnly: readOnly,
      ),
    );
  }

  Widget _buildCustomSizedElevatedButton({
    required VoidCallback onPressed,
    required String text,
    bool isCancelButton = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isCancelButton
              ? const BorderSide(color: Color(0xff6502D4), width: 2)
              : BorderSide.none,
        ),
        backgroundColor:
            isCancelButton ? Colors.transparent : const Color(0xff6502D4),
        elevation: isCancelButton ? 0 : 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: isCancelButton ? const Color(0xff6502D4) : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff6502d4),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Editor de ligação',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Nome do Cliente'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: clientController,
                hintText: 'Cliente',
                readOnly: true,
              ),
              const SizedBox(height: 16),
              _buildTitle('Contato'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: contactController,
                hintText: 'Contato',
                readOnly: true,
              ),
              const SizedBox(height: 16),
              _buildTitle('Resultado'),
              const SizedBox(height: 5),
              DropdownButtonFormField<int>(
                value: selectedResultId,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF0F0F7),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Atendido')),
                  DropdownMenuItem(value: 2, child: Text('Desligado')),
                  DropdownMenuItem(value: 3, child: Text('Cx. Postal')),
                  DropdownMenuItem(value: 4, child: Text('Ocupado')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedResultId = value ?? 1;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTitle('Data'),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    dateController.text = formattedDate;
                  }
                },
                child: AbsorbPointer(
                  child: _buildHalfWidthTextField(
                    controller: dateController,
                    hintText: '00/00/0000',
                    keyboardType: TextInputType.datetime,
                    readOnly: false,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle('Hora'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: timeController,
                          hintText: '--:--',
                          inputFormatters: [MaskedInputFormatter('00:00')],
                          keyboardType: TextInputType.datetime,
                          readOnly: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle('Duração'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: durationController,
                          hintText: '--:--',
                          inputFormatters: [MaskedInputFormatter('00:00')],
                          keyboardType: TextInputType.datetime,
                          readOnly: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTitle('Descrição'),
              const SizedBox(height: 5),
              _buildTextField(
                controller: descriptionController,
                hintText: 'Descrição',
                maxLines: 3,
                readOnly: false,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildCustomSizedElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Cancelar',
                      isCancelButton: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCustomSizedElevatedButton(
                      onPressed: () async {
                        final updatedClientData = {
                          'idLead': widget.clientData['id'],
                          'contact': contactController.text,
                          'date': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                              .format(DateFormat('dd/MM/yyyy')
                                  .parse(dateController.text)),
                          'duration': durationController.text,
                          'description': descriptionController.text,
                          'result': {
                            'idLeadResult': selectedResultId,
                          },
                          'clientTime': timeController.text,
                        };

                        await widget.onEdit(updatedClientData);
                        Navigator.pop(context);
                      },
                      text: 'Salvar',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await widget.onDelete(widget.clientData['idLead'].toString());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF6502D4),
                    elevation: 2,
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.5, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Excluir',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
