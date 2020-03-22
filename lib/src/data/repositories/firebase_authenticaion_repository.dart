import 'dart:async';
import 'package:train_beers/src/domain/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<String> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => user.uid);
  }

  @override
  Future<String> login(String email, String password) async {
      AuthResult authResult =   await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user == null) {
        return "";
      }

      return authResult.user.uid;
  }

  @override
  Future logout() async => await _auth.signOut();
}
