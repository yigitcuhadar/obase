import 'package:formz/formz.dart';

enum ProductDescriptionValidationError { invalid, empty }

class ProductDescriptionForm extends FormzInput<String, ProductDescriptionValidationError> {
  const ProductDescriptionForm.pure([super.value = '']) : super.pure();

  const ProductDescriptionForm.dirty([super.value = '']) : super.dirty();

  @override
  ProductDescriptionValidationError? validator(String value) {
    if (value.isEmpty) {
      return ProductDescriptionValidationError.empty;
    } else if (value.length < 8 || value.length > 80) {
      return ProductDescriptionValidationError.invalid;
    }
    return null;
  }
}
