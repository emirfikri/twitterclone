import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:twitter/models/user.dart';

// import 'package:twitter/services/utils.dart';

import '../Models/userModel.dart';

class UserRepo {
  // final UtilsService _utilsService = UtilsService();

  List<UserModel> _userListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
        uid: doc.id,
        displayName: doc.get('name') ?? '',
        photoURL: doc.get('photoURL') ?? '',
        email: doc.get('email') ?? '',
      );
    }).toList();
  }

  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      uid: snapshot.id,
      displayName: snapshot.get('displayName') ?? '',
      photoURL: snapshot.get('photoURL') ?? '',
      email: snapshot.get('email') ?? '',
    );
  }

  Stream<UserModel?> getUserInfo(uid) {
    var user = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
    return user;
  }

  Future<List<String>> getUserFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();

    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
  }
}
