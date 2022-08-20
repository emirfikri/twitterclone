import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String creator;
  final String text;
  final Timestamp timestamp;
  final String originalId;
  final bool retweet;
  DocumentReference ref;

  int likesCount;
  int retweetsCount;

  PostModel(
      {required this.id,
      required this.creator,
      required this.text,
      required this.timestamp,
      required this.likesCount,
      required this.retweetsCount,
      required this.originalId,
      required this.retweet,
      required this.ref});

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    DocumentReference ref = doc.reference;
    Map<dynamic, dynamic> data = doc.data()! as Map;

    return PostModel.fromJson(data, ref);
  }

  factory PostModel.fromJson(
      Map<dynamic, dynamic> json, DocumentReference ref) {
    final id = json['id'] ?? '';
    final creator = json['creator'] ?? '';
    final text = json['text'] ?? '';
    final timestamp = json['timestamp'];
    final likesCount = json['likesCount'] ?? '';
    final retweetsCount = json['retweetsCount'] ?? '';
    final originalId = json['originalId'] ?? '';
    final retweet = json['retweet'] ?? '';

    return PostModel(
      id: id,
      creator: creator,
      text: text,
      timestamp: timestamp,
      likesCount: likesCount,
      retweetsCount: retweetsCount,
      originalId: originalId,
      retweet: retweet,
      ref: ref,
    );
  }
}
