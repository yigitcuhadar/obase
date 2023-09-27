import '../models/user.dart';

abstract class AuthRepository {
  late final Stream<User?> user;

  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> signup({
    required String email,
    required String password,
  });

  Future<void> logout();
}
