import 'package:formz/formz.dart';

enum ProductNameValidationError { invalid, empty }

class ProductNameForm extends FormzInput<String, ProductNameValidationError> {
  const ProductNameForm.pure([super.value = '']) : super.pure();

  const ProductNameForm.dirty([super.value = '']) : super.dirty();

  @override
  ProductNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return ProductNameValidationError.empty;
    } else if (value.length < 4 || value.length > 20) {
      return ProductNameValidationError.invalid;
    }
    return null;
  }
}
