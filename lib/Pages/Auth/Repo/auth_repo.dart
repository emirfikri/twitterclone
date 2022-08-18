import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_firestore_provider.dart';
import '/Pages/Auth/Repo/auth_provider.dart';

class AuthRepository {
  final _authprovider = AuthProvider();
  final _firestoreprovider = AuthFireStoreProvider();

  Future<void> signUp(
      {required String displayName,
      required String email,
      required String password}) async {
    UserCredential credential = await _authprovider
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(displayName);
    print(credential.user!);
    if (credential.runtimeType == UserCredential) {
      await _firestoreprovider.createNewUser(
        user: credential.user,
        displayName: displayName,
        password: password,
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
