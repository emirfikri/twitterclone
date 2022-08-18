import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthFireStoreProvider {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createNewUser(
      {User? user,
      required String displayName,
      required String password}) async {
    Map<String, dynamic> mapData = {
      "uid": user!.uid,
      "email": user.email,
      "displayName": displayName,
      "password": password,
      "photoURL": user.photoURL,
      "register": DateTime.now(),
      "lastUsed": DateTime.now(),
      "lastLogin": DateTime.now(),
    };
    await _firestore
        .collection("users")
        .doc(user.uid)
        .set(mapData)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> updateLastLogin({required String uid}) async {
    var updateData = {
      "lastUsed": DateTime.now(),
      "lastLogin": DateTime.now(),
    };
    await _firestore
        .collection("User")
        .doc(uid)
        .update(updateData)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> updateLastUsed({required String uid}) async {
    await _firestore
        .collection("User")
        .doc(uid)
        .update({"lastUsed": DateTime.now()}).catchError((e) {
      debugPrint(e.toString());
    });
  }
}
