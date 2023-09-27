import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ob_auth/ob_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository repository;
  late final StreamSubscription<User?> user;

  AuthenticationBloc({required this.repository}) : super(UnauthenticatedState()) {
    user = repository.user.listen(_handleUserChanged);
    on<AuthenticationChangedEvent>(_handleAuthenticationChangedEvenet);
  }

  Future<void> _handleUserChanged(User? user) async {
    add(AuthenticationChangedEvent(user: user));
  }

  Future<void> _handleAuthenticationChangedEvenet(
    AuthenticationChangedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthenticatedState(user: event.user!));
    } else {
      emit(UnauthenticatedState());
    }
  }

  @override
  Future<void> close() {
    user.cancel();
    return super.close();
  }
}
