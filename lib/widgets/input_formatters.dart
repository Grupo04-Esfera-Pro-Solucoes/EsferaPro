import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formattedText = '';
    if (newText.length >= 3) {
      formattedText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }
    if (newText.length >= 5) {
      formattedText = '${newText.substring(0, 2)}/${newText.substring(2, 4)}/${newText.substring(4, 8)}';
    } else if (newText.length < 3) {
      formattedText = newText;
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formattedText = '';
    if (newText.length >= 7) {
      formattedText = '(${newText.substring(0, 2)}) ${newText.substring(2, 7)}-${newText.length > 7 ? newText.substring(7, 11) : ''}';
    } else if (newText.length >= 3) {
      formattedText = '(${newText.substring(0, 2)}) ${newText.substring(2)}';
    } else {
      formattedText = newText;
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class ZipCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formattedText = '';
    if (newText.length >= 5) {
      formattedText = '${newText.substring(0, 5)}-${newText.length > 5 ? newText.substring(5, 8) : ''}';
    } else {
      formattedText = newText;
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
