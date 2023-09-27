import 'package:flutter/services.dart';
import 'package:formz/formz.dart';

enum BarcodeFormValidationError { invalid, empty }

class BarcodeForm extends FormzInput<String, BarcodeFormValidationError> {
  const BarcodeForm.pure([super.value = '']) : super.pure();

  const BarcodeForm.dirty([super.value = '']) : super.dirty();

  int get intValue => int.parse(cleanValue);

  String get cleanValue => value.replaceAll(' ', '');

  @override
  BarcodeFormValidationError? validator(String value) {
    if (value.isEmpty) {
      return BarcodeFormValidationError.empty;
    } else if (cleanValue.length != 13 || !isEan13) {
      return BarcodeFormValidationError.invalid;
    }
    return null;
  }

  bool get isEan13 {
    String data = cleanValue;
    var sum = 0;
    var isThree = false;
    for (var i = data.length - 1; i >= 0; i--) {
      final digit = data.codeUnitAt(i) - 48;
      if (isThree) {
        sum += digit * 3;
      } else {
        sum += digit;
      }
      isThree = !isThree;
    }
    return sum % 10 == 0;
  }
}

class BarcodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var inputText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue == 1 || nonZeroIndexValue == 7 || nonZeroIndexValue == 13 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }
    var string = bufferString.toString();
    if (oldValue.text.length > newValue.text.length && (newValue.text.length == 1 || newValue.text.length == 7)) {
      string = string.substring(0, string.length - 1);
    }
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
