  import 'package:flutter/material.dart';
  import 'package:esferapro/service/createProposal_service.dart';
  import 'package:file_picker/file_picker.dart';
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
              // file: _selectedFile != null ? _selectedFile! : File(''),
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      );

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
                              child: TextFormField(
                                controller: _leadId,
                                decoration: inputDecoration.copyWith(
                                  labelText: 'ID da Ligação',
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 22,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _date,
                                decoration: inputDecoration.copyWith(
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
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _value,
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
                              return 'Campo obrigatório';
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
                                controller: _clientId,
                                decoration: inputDecoration.copyWith(
                                  labelText: 'ID do Cliente',
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 22,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _clientName,
                                decoration: inputDecoration.copyWith(
                                  labelText: 'Nome do Cliente',
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<int>(
                          decoration: inputDecoration.copyWith(
                            labelText: 'Status da Proposta',
                            contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                          ),
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
                        TextFormField(
                          controller: _service,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Solução',
                          ),
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                          ),
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
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _description,
                          maxLines: 5,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Descrição da Tarefa',
                          ),
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                          ),
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
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0xFF475467)),
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Color(0xFF475467)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 140,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6502D4),
                                ),
                                onPressed: _postNewProposal,
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(color: Colors.white),
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
