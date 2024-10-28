import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HybridCpfCnpjInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const HybridCpfCnpjInput({
    super.key,
    required this.controller,
    required this.hintText,
  });

  void _onChanged(String value) {
    String digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length <= 11) {
      controller.value = TextEditingValue(text: _formatCpf(digits));
    } else if (digits.length <= 14) {
      controller.value = TextEditingValue(text: _formatCnpj(digits));
    }
  }

  String _formatCpf(String cpf) {
    if (cpf.length <= 3) return cpf;
    if (cpf.length <= 6) return '${cpf.substring(0, 3)}.${cpf.substring(3)}';
    if (cpf.length <= 9) return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6)}';
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  String _formatCnpj(String cnpj) {
    if (cnpj.length <= 2) return cnpj;
    if (cnpj.length <= 5) return '${cnpj.substring(0, 2)}.${cnpj.substring(2)}';
    if (cnpj.length <= 8) return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5)}';
    if (cnpj.length <= 12) return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8)}';
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12)}';
  }

  @override
  Widget build(BuildContext context) {
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
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(14),
        ],
        keyboardType: TextInputType.number,
        onChanged: _onChanged,
      ),
    );
  }
}