import 'package:formz/formz.dart';

enum ProductPhotoUrlValidationError { invalid, empty }

class ProductPhotoUrlForm extends FormzInput<String, ProductPhotoUrlValidationError> {
  static final _photoUrlRegExp = RegExp(
    r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
  );

  const ProductPhotoUrlForm.pure([super.value = '']) : super.pure();

  const ProductPhotoUrlForm.dirty([super.value = '']) : super.dirty();

  @override
  ProductPhotoUrlValidationError? validator(String value) {
    if (value.isEmpty) {
      return ProductPhotoUrlValidationError.empty;
    } else if (!_photoUrlRegExp.hasMatch(value)) {
      return ProductPhotoUrlValidationError.invalid;
    }
    return null;
  }
}
