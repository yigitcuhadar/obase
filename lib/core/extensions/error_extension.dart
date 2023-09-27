import 'package:ob_auth/ob_auth.dart';
import 'package:obase_barcode/core/extensions/context_extension.dart';
import 'package:obase_barcode/core/lang/locale_keys.g.dart';

extension AuthErrorExtension on AuthError {
  String get errorText {
    switch (this) {
      case AuthError.invalidEmail:
        return LocaleKeys.exception_auth_invalid_email.locale;
      case AuthError.userDisabled:
        return LocaleKeys.exception_auth_user_disabled.locale;
      case AuthError.userNotFound:
        return LocaleKeys.exception_auth_user_not_found.locale;
      case AuthError.wrongPassword:
        return LocaleKeys.exception_auth_wrong_password.locale;
      case AuthError.emailAlreadyInUse:
        return LocaleKeys.exception_auth_email_already_in_use.locale;
      case AuthError.invalidCredential:
        return LocaleKeys.exception_auth_invalid_credential.locale;
      case AuthError.operationNotAllowed:
        return LocaleKeys.exception_auth_operation_not_allowed.locale;
      case AuthError.weakPassword:
        return LocaleKeys.exception_auth_weak_password.locale;
      case AuthError.unknown:
        return LocaleKeys.exception_auth_unknown.locale;
    }
  }
}
