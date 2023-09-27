part of 'signup_cubit.dart';

class SignupState extends Equatable {
  final EmailForm emailForm;
  final PasswordForm passwordForm;
  final ConfirmedPasswordForm confirmedPasswordForm;
  final FormzSubmissionStatus status;
  final AuthError? error;
  final bool isValid;

  const SignupState({
    this.emailForm = const EmailForm.pure(),
    this.passwordForm = const PasswordForm.pure(),
    this.confirmedPasswordForm = const ConfirmedPasswordForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error,
    this.isValid = false,
  });
  SignupState copyWith({
    EmailForm? emailForm,
    PasswordForm? passwordForm,
    ConfirmedPasswordForm? confirmedPasswordForm,
    FormzSubmissionStatus? status,
    AuthError? error,
    bool? isValid,
  }) {
    return SignupState(
      emailForm: emailForm ?? this.emailForm,
      passwordForm: passwordForm ?? this.passwordForm,
      confirmedPasswordForm: confirmedPasswordForm ?? this.confirmedPasswordForm,
      status: status ?? this.status,
      error: error ?? this.error,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [emailForm, passwordForm, confirmedPasswordForm, status, error, isValid];
}
