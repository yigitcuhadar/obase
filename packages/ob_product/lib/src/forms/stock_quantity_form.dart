import 'package:formz/formz.dart';

enum StockQuantityValidationError { invalid, empty }

class StockQuantityForm extends FormzInput<String, StockQuantityValidationError> {
  const StockQuantityForm.pure([super.value = '']) : super.pure();

  const StockQuantityForm.dirty([super.value = '']) : super.dirty();

  int get intValue => int.parse(value);

  @override
  StockQuantityValidationError? validator(String value) {
    int? parse = int.tryParse(value);
    if (value.isEmpty) {
      return StockQuantityValidationError.empty;
    } else if (parse == null || parse < 0 || parse > 9999) {
      return StockQuantityValidationError.invalid;
    }
    return null;
  }
}
