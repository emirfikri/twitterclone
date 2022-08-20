import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/iterables.dart';
import 'package:twitterclone/Pages/Post/Repo/post_firestore_provider.dart';

import '../../../Models/postModel.dart';

class PostRepo {
  final PostFirestoreProvider postFirestoreProvider = PostFirestoreProvider();

  PostModel _postFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.exists
        ? PostModel(
            id: snapshot.id,
            text: snapshot.get('text') ?? '',
            creator: snapshot.get('creator') ?? '',
            timestamp: snapshot.get('timestamp') ?? 0,
            likesCount: snapshot.get('likesCount') ?? 0,
            retweetsCount: snapshot.get('retweetsCount') ?? 0,
            retweet: snapshot.get('retweet') ?? false,
            originalId: snapshot.get('originalId') ?? null,
            ref: snapshot.reference,
          )
        : PostModel(
            id: '',
            text: '',
            creator: '',
            timestamp: Timestamp.now(),
            likesCount: 0,
            retweetsCount: 0,
            retweet: false,
            originalId: "",
            ref: snapshot.reference,
          );
  }

  Future savePost(text) async {
    await postFirestoreProvider.savePost(text);
  }

  Future editPost(PostModel post, String text) async {
    await postFirestoreProvider.saveEditPost(post, text);
  }

  Future likePost(PostModel post, bool current) async {
    print(post.id);
    if (current) {
      post.likesCount = post.likesCount - 1;
      await postFirestoreProvider.dislikePost(post);
    }
    if (!current) {
      post.likesCount = post.likesCount + 1;
      await postFirestoreProvider.likePost(post);
    }
  }

  Future deletePost(PostModel post) async {
    await FirebaseFirestore.instance.collection("posts").doc(post.id).delete();
  }

  Stream<bool> getcurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future<PostModel> getPostById(String id) async {
    DocumentSnapshot postSnap =
        await FirebaseFirestore.instance.collection("posts").doc(id).get();

    return _postFromSnapshot(postSnap);
  }

  Stream getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeed() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
