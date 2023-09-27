import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:ob_auth/ob_auth.dart';
import 'package:ob_product/ob_product.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';

import '../lang/locale_keys.g.dart';

extension FormzSubmissionStatusExtension on FormzSubmissionStatus {
  Color get toColor {
    switch (this) {
      case FormzSubmissionStatus.success:
        return Colors.green.shade900;
      case FormzSubmissionStatus.failure:
        return Colors.red.shade900;
      case FormzSubmissionStatus.initial:
      case FormzSubmissionStatus.inProgress:
      case FormzSubmissionStatus.canceled:
        return Colors.black;
    }
  }
}

extension EmailFormExtension on EmailForm {
  String? get errorText {
    switch (displayError) {
      case EmailValidationError.invalid:
        return LocaleKeys.form_email_invalid_error.locale;
      case EmailValidationError.empty:
        return LocaleKeys.form_email_empty_error.locale;
      case null:
        return null;
    }
  }
}

extension PasswordFormExtension on PasswordForm {
  String? get errorText {
    switch (displayError) {
      case PasswordValidationError.invalid:
        return LocaleKeys.form_password_invalid_error.locale;
      case PasswordValidationError.empty:
        return LocaleKeys.form_password_empty_error.locale;
      case null:
        return null;
    }
  }
}

extension ConfirmedPasswordFormExtension on ConfirmedPasswordForm {
  String? get errorText {
    switch (displayError) {
      case ConfirmedPasswordValidationError.invalid:
        return LocaleKeys.form_confirmed_password_invalid_error.locale;
      case ConfirmedPasswordValidationError.empty:
        return LocaleKeys.form_confirmed_password_empty_error.locale;
      case null:
        return null;
    }
  }
}

extension ProductNameFormExtension on ProductNameForm {
  String? get errorText {
    switch (displayError) {
      case ProductNameValidationError.invalid:
        return LocaleKeys.form_product_name_invalid_error.locale;
      case ProductNameValidationError.empty:
        return LocaleKeys.form_product_name_empty_error.locale;
      case null:
        return null;
    }
  }
}

extension ProductDescriptionFormExtension on ProductDescriptionForm {
  String? get errorText {
    switch (displayError) {
      case ProductDescriptionValidationError.invalid:
        return LocaleKeys.form_product_description_invalid_error.locale;
      case ProductDescriptionValidationError.empty:
        return LocaleKeys.form_product_description_empty_error.locale;
      case null:
        return null;
    }
  }
}

extension ProductPhotoUrlFormExtension on ProductPhotoUrlForm {
  String? get errorText {
    switch (displayError) {
      case ProductPhotoUrlValidationError.invalid:
        return LocaleKeys.form_product_photo_url_invalid_error.locale;
      case ProductPhotoUrlValidationError.empty:
        return LocaleKeys.form_product_photo_url_empty_error.locale;
      case null:
        return null;
    }
  }
}

extension StockQuantityFormExtension on StockQuantityForm {
  String? get errorText {
    switch (displayError) {
      case StockQuantityValidationError.invalid:
        return LocaleKeys.form_stock_quantity_invalid_error.locale;
      case StockQuantityValidationError.empty:
        return LocaleKeys.form_stock_quantity_empty_error.locale;
      case null:
        return null;
    }
  }
}
