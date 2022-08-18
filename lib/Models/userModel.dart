// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  bool? isVerified;
  final String? email;
  String? password;
  final String? displayName;
  final String? photoURL;
  UserModel({
    this.photoURL,
    this.uid,
    this.email,
    this.password,
    this.displayName,
    this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'uid': uid,
      'photoURL': photoURL,
    };
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        email = doc.data()!["email"],
        photoURL = doc.data()!["photoURL"],
        displayName = doc.data()!["displayName"];

  UserModel copyWith({
    bool? isVerified,
    String? uid,
    String? email,
    String? password,
    String? displayName,
    String? photoURL,
  }) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        password: password ?? this.password,
        displayName: displayName ?? this.displayName,
        photoURL: photoURL ?? this.photoURL,
        isVerified: isVerified ?? this.isVerified);
  }
}
