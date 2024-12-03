import 'package:esferapro/service/proposal_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class StackProposalEdit extends StatefulWidget {
  final Map<String, dynamic> proposalData;
  final Future<void> Function(Map<String, dynamic> updatedProposalData) onEdit;
  final Future<void> Function(String) onDelete;

  const StackProposalEdit({
    required this.proposalData,
    required this.onEdit,
    required this.onDelete,
  });

    @override
  _StackProposalEditState createState() => _StackProposalEditState();
}

class _StackProposalEditState extends State<StackProposalEdit> {
  late TextEditingController serviceController;
  late TextEditingController descriptionController;
  late TextEditingController statusController;
  late TextEditingController valueController;
  late TextEditingController dateController;
  late TextEditingController leadIdController;
  late TextEditingController clientIdController;
  late TextEditingController clientNameController;
  late TextEditingController fileController;

  int selectedStatusId = 1;
  File? selectedFile;
  List<Map<String, dynamic>> _statusOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchStatusProposals();

    serviceController = TextEditingController(text: widget.proposalData['service'] ?? '');
    descriptionController = TextEditingController(text: widget.proposalData['description'] ?? '');
    statusController = TextEditingController(text: widget.proposalData['status']?.toString() ?? '');
    valueController = TextEditingController(text: widget.proposalData['value']?.toString() ?? '');
    dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.proposalData['proposalDate'] ?? DateTime.now().toString())));
    leadIdController = TextEditingController(text: widget.proposalData['idLead']['idLead']?.toString() ?? '');
    clientIdController = TextEditingController(text: widget.proposalData['idLead']['idClient']['idClient']?.toString() ?? '');
    clientNameController = TextEditingController(text: widget.proposalData['idLead']['idClient']['name'] ?? '');
    selectedStatusId = widget.proposalData['idStatusProposal']['idStatusProposal'] ?? 1;
    fileController = TextEditingController();
    selectedFile = null;
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _fetchStatusProposals() async {
    try {
      final statusProposals = await ProposalService().getAllStatusProposals();
      setState(() {
        _statusOptions = statusProposals;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar status das propostas: $e')),
      );
    }
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
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Edição de Propostas',
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _buildTitle('ID da Ligação'),
                              const SizedBox(height: 5),
                              _buildTextField(
                                controller: leadIdController,
                                hintText: 'ID da Ligação',
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _buildTitle('Data da Proposta'),
                              const SizedBox(height: 5),
                              Stack(
                                children: [
                                  _buildTextField(
                                    controller: dateController,
                                    hintText: '00/00/0000',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      DateInputFormatter(),
                                    ],
                                    readOnly: false,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.calendar_today, color: Colors.grey),
                                      onPressed: () => _selectDate(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        _buildTitle('Valor da Proposta'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: valueController,
                          hintText: 'Valor da proposta',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          readOnly: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _buildTitle('ID do Cliente', isRequired: true),
                              const SizedBox(height: 5),
                              _buildTextField(
                                controller: clientIdController,
                                hintText: 'ID do Cliente',
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _buildTitle('Nome do Cliente'),
                              const SizedBox(height: 5),
                              _buildTextField(
                                controller: clientNameController,
                                hintText: 'Nome do Cliente',
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _buildTitle('Status da Proposta', isRequired: true),
                              const SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: DropdownButtonFormField<int>(
                                  value: selectedStatusId,
                                  hint: const Text(
                                    'Escolha o status da proposta',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  items: _statusOptions.map((status) {
                                    return DropdownMenuItem<int>(
                                      value: status['idStatusProposal'],
                                      child: Text(
                                        status['name'],
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                          color: Color(0xFF475467),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    selectedStatusId = newValue!;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9393C2)),
                                  dropdownColor: const Color(0xFFF0F0F7),
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Color(0xFF475467),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        _buildTitle('Solução'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: serviceController,
                          hintText: 'Digite a solução',
                          readOnly: true,
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
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.any,
                            allowMultiple: false,
                          );

                          if (result != null) {
                            setState(() {
                              selectedFile = File(result.files.single.path!);
                              fileController.text = "${result.files.single.name} anexado";
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Arquivo selecionado com sucesso!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Nenhum arquivo selecionado.')),
                            );
                          }
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
                            children: [
                              const Icon(
                                Icons.attach_file,
                                color: Color(0xFF475467),
                                size: 30.0,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                fileController.text.isEmpty
                                    ? 'Clique aqui para anexar um arquivo'
                                    : fileController.text,
                                style: const TextStyle(
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
                        'Descrição da Proposta',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      controller: descriptionController,
                      hintText: 'Digite a descrição da Proposta',
                      maxLines: 5,
                      readOnly: false,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildCustomSizedElevatedButton(
                            onPressed: () async {
                              final updatedProposalData = {
                                'idLead': widget.proposalData['idLead']['idLead'],
                                'service': serviceController.text,
                                'proposalDate': DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                    .format(DateFormat('dd/MM/yyyy')
                                    .parse(dateController.text)),
                                'value': valueController.text,
                                'description': descriptionController.text,
                                'idStatusProposal': {
                                  'idStatusProposal': selectedStatusId,
                                },
                                'file': selectedFile,
                              };

                              await widget.onEdit(updatedProposalData);
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
                          await widget.onDelete(widget.proposalData['idProposal'].toString());
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9/]'), '');
    if (text.length > 10) {
      text = text.substring(0, 10);
    }
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }
    var formattedText = buffer.toString();
    if (formattedText.length > 10) {
      formattedText = formattedText.substring(0, 10);
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (newText.isNotEmpty) {
      newText = 'R\$ ${double.parse(newText) / 100}';
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
