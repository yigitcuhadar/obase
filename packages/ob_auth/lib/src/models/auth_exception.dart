enum AuthError {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidCredential,
  operationNotAllowed,
  weakPassword,
  unknown,
}

class AuthException implements Exception {
  final AuthError error;
  const AuthException(this.error);
}
