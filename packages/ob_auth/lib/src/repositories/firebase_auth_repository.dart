import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/auth_exception.dart';
import '../models/user.dart';
import 'auth_repository.dart';

extension FirebaseUserExtension on auth.User {
  User toUser() {
    var splittedName = ['Name ', 'LastName'];
    if (displayName != null) {
      splittedName = displayName!.split(' ');
    }

    final map = <String, dynamic>{
      'id': uid,
      'firstName': splittedName.first,
      'lastName': splittedName.last,
      'email': email ?? '',
      'emailVerified': emailVerified,
      'imageUrl': photoURL ?? '',
      'isAnonymous': isAnonymous,
      'age': 0,
      'phoneNumber': '',
      'address': '',
    };
    return User.fromJson(map);
  }
}

class FirebaseAuthRepository implements AuthRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  @override
  Stream<User?> user = auth.FirebaseAuth.instance.authStateChanges().map((auth.User? user) => user?.toUser());

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.toUser();
    } on auth.FirebaseAuthException catch (e) {
      throw AuthException(_determineError(e));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signup({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _firebaseAuth.currentUser!.toUser();
    } on auth.FirebaseAuthException catch (e) {
      throw AuthException(_determineError(e));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on auth.FirebaseAuthException catch (e) {
      throw AuthException(_determineError(e));
    } catch (e) {
      rethrow;
    }
  }

  AuthError _determineError(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'user-disabled':
        return AuthError.userDisabled;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError.emailAlreadyInUse;
      case 'invalid-credential':
        return AuthError.invalidCredential;
      case 'operation-not-allowed':
        return AuthError.operationNotAllowed;
      case 'weak-password':
        return AuthError.weakPassword;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError.unknown;
    }
  }
}
