import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ob_auth/ob_auth.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _repository;
  SignupCubit({
    required AuthRepository repository,
  })  : _repository = repository,
        super(const SignupState());

  void onEmailChanged(String value) async {
    EmailForm emailForm = EmailForm.dirty(value);
    emit(state.copyWith(
      emailForm: emailForm,
      isValid: Formz.validate([emailForm, state.passwordForm, state.confirmedPasswordForm]),
    ));
  }

  void onPasswordChanged(String value) async {
    PasswordForm passwordForm = PasswordForm.dirty(value);
    ConfirmedPasswordForm confirmedPasswordForm = ConfirmedPasswordForm.dirty(
      value: state.confirmedPasswordForm.value,
      password: value,
    );
    emit(state.copyWith(
      passwordForm: passwordForm,
      confirmedPasswordForm: confirmedPasswordForm,
      isValid: Formz.validate([state.emailForm, passwordForm, confirmedPasswordForm]),
    ));
  }

  void onConfirmedPasswordChanged(String value) async {
    ConfirmedPasswordForm confirmedPasswordForm = ConfirmedPasswordForm.dirty(
      value: value,
      password: state.passwordForm.value,
    );
    emit(state.copyWith(
      confirmedPasswordForm: confirmedPasswordForm,
      isValid: Formz.validate([state.emailForm, state.passwordForm, confirmedPasswordForm]),
    ));
  }

  void onSubmitted() async {
    if (state.isValid) {
      try {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        await _repository.signup(
          email: state.emailForm.value,
          password: state.passwordForm.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on AuthException catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, error: e.error));
      }
    }
  }
}
