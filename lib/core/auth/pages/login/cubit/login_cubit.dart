import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ob_auth/ob_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  LoginCubit({
    required AuthRepository repository,
  })  : _repository = repository,
        super(const LoginState());

  void onEmailChanged(String value) async {
    EmailForm emailForm = EmailForm.dirty(value);
    emit(state.copyWith(
      emailForm: emailForm,
      isValid: Formz.validate([emailForm, state.passwordForm]),
    ));
  }

  void onPasswordChanged(String value) async {
    PasswordForm passwordForm = PasswordForm.dirty(value);
    emit(state.copyWith(
      passwordForm: passwordForm,
      isValid: Formz.validate([state.emailForm, passwordForm]),
    ));
  }

  void onSubmitted() async {
    if (state.isValid) {
      try {
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        await _repository.login(
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
