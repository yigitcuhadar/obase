part of 'login_cubit.dart';

class LoginState extends Equatable {
  final EmailForm emailForm;
  final PasswordForm passwordForm;
  final AuthError? error;
  final FormzSubmissionStatus status;
  final bool isValid;

  const LoginState({
    this.emailForm = const EmailForm.pure(),
    this.passwordForm = const PasswordForm.pure(),
    this.error,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });
  LoginState copyWith({
    EmailForm? emailForm,
    PasswordForm? passwordForm,
    FormzSubmissionStatus? status,
    AuthError? error,
    bool? isValid,
  }) {
    return LoginState(
      emailForm: emailForm ?? this.emailForm,
      passwordForm: passwordForm ?? this.passwordForm,
      status: status ?? this.status,
      error: error ?? this.error,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [emailForm, passwordForm, error, status];
}
