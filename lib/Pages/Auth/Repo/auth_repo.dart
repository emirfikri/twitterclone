import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Pages/Auth/Repo/firestore_provider.dart';
import '/Pages/Auth/Repo/auth_provider.dart';

class AuthRepository {
  final _authprovider = AuthProvider();
  final _firestoreprovider = FireStoreProvider();

  Future<void> signUp(
      {required String username,
      required String email,
      required String password}) async {
    UserCredential credential = await _authprovider
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(username);

    if (credential.runtimeType == UserCredential) {
      await _firestoreprovider.createNewUser(
        user: credential.user,
        username: username,
      );
    }
  }

  Future signIn({
    required String email,
    required String password,
  }) async {
    await _authprovider.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _authprovider.signOut();
  }

  Stream<User?> authStateChange() {
    return _authprovider.onAuthStateChanges();
  }
}
