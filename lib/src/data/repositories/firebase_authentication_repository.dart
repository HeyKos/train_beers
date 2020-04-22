import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/authentication_repository.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<String> get user {
    return _auth.onAuthStateChanged.map((user) => user.uid);
  }

  @override
  Future<String> login(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (authResult.user == null) {
      return '';
    }

    return authResult.user.uid;
  }

  @override
  Future<void> logout() async => await _auth.signOut();
}
