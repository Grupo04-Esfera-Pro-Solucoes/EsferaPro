  import 'package:flutter/material.dart';
  import 'package:esferapro/service/createProposal_service.dart';
  import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
  import 'package:intl/intl.dart';
  import 'dart:io';

  class ProposalCadastro extends StatefulWidget {
    @override
    _ProposalCadastroState createState() => _ProposalCadastroState();
  }

  class _ProposalCadastroState extends State<ProposalCadastro> {
    final TextEditingController _service = TextEditingController();
    final TextEditingController _description = TextEditingController();
    final TextEditingController _value = TextEditingController();
    final TextEditingController _date = TextEditingController();
    final TextEditingController _leadId = TextEditingController();
    final TextEditingController _clientId = TextEditingController();
    final TextEditingController _clientName = TextEditingController();
    final TextEditingController _file = TextEditingController();
    File? _selectedFile;

    final ProposalService _createProposalService = ProposalService();
    List<Map<String, dynamic>> _statusOptions = [];
    int? _selectedStatus;
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
      super.initState();
      _fetchStatusOptions();
      _leadId.addListener(_fetchClientDetails);
    }

    Future<void> _fetchStatusOptions() async {
      List<dynamic> statusList = await _createProposalService.getAllStatusProposals();
      setState(() {
        _statusOptions = statusList.map((status) {
          return {
            'idStatusProposal': status['idStatusProposal'],
            'name': status['name'],
          };
        }).toList();
      });
    }

    Future<void> _fetchClientDetails() async {
      if (_leadId.text.isNotEmpty) {
        try {
          int idLead = int.parse(_leadId.text);
          Map<String, dynamic> proposalDetails = await _createProposalService.fetchSearchProposalByName(idLead);
          setState(() {
            _clientId.text = proposalDetails['idClient']['idClient'].toString();
            _clientName.text = proposalDetails['idClient']['name'].toString();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao buscar detalhes do cliente')),
          );
        }
      }
    }

    void _postNewProposal() {
      if (_formKey.currentState!.validate()) {
        _createProposalService
            .postNewProposal(
              idLead: int.parse(_leadId.text),
              completionDate: DateFormat('yyyy-MM-dd')
                  .format(DateFormat('dd/MM/yyyy').parse(_date.text)),
              description: _description.text,
              service: _service.text,
              value: double.parse(_value.text),
              idStatusProposal: _selectedStatus!, 
              clientId: _clientId.text,
              file: _selectedFile != null ? _selectedFile! : File(''),
            )
            .then((_) {
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar proposta: $error')),
          );
        });
      }
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
          _date.text = DateFormat('dd/MM/yyyy').format(picked);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.description, color: Color(0xFFF7BD2E)),
              SizedBox(width: 8.0),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                _buildTitle('ID da Ligação'),
                                const SizedBox(height: 5),
                                _buildTextField(
                                  controller: _leadId,
                                  hintText: 'Digite ID da Ligação',
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
                                _buildTitle('Data de Conclusão'),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: _buildTextField(
                                      controller: _date,
                                      hintText: '00/00/0000',
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
                          _buildTitle('Valor da Proposta'),
                          const SizedBox(height: 5),
                          _buildTextField(
                            controller: _value,
                            hintText: 'Digite o valor da proposta',
                            keyboardType: TextInputType.number,
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
                                _buildTitle('ID do Cliente'),
                                const SizedBox(height: 5),
                                _buildTextField(
                                  controller: _clientId,
                                  hintText: 'Digite ID do Cliente',
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
                                  controller: _clientName,
                                  hintText: 'Digite Nome do Cliente',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<int>(
                          value: _selectedStatus,
                          items: _statusOptions.map((status) {
                            return DropdownMenuItem<int>(
                              value: status['idStatusProposal'],
                              child: Text(
                                status['name'],
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 22,
                                  color: Color(0xFF475467),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedStatus = newValue;
                            });
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
                            fontSize: 22,
                            color: Color(0xFF475467),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          _buildTitle('Solução'),
                          const SizedBox(height: 5),
                          _buildTextField(
                            controller: _service,
                            hintText: 'Digite a solução',
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
                                  _selectedFile = File(result.files.single.path!);
                                  _file.text = "${result.files.single.name} anexado";
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
                                    _selectedFile == null ? 'Clique aqui para anexar um arquivo' : _file.text,
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
                            'Descrição da Tarefa',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
                      _buildTextField(
                        controller: _description,
                        hintText: 'Digite a descrição da tarefa',
                        maxLines: 5,
                      ),
                        const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomSizedElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'Cancelar',
                              isCancelButton: true,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomSizedElevatedButton(
                              onPressed: _postNewProposal,
                              text: 'Salvar',
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
      Widget _buildTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
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
      ),
    );
  }

  Widget _buildHalfWidthTextField({
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
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
      ),
    );
  }
}

class CustomSizedElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isCancelButton;

  const CustomSizedElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isCancelButton
              ? const BorderSide(color: Color(0xff6502D4), width: 2)
              : BorderSide.none,
        ),
        backgroundColor: isCancelButton ? Colors.transparent : const Color(0xff6502D4),
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
}
