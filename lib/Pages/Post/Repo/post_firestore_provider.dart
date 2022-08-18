// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Models/postModel.dart';

class PostFirestoreProvider {
  Future savePost(text) async {
    var doc = await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': false,
      'likesCount': 0,
      'retweetsCount': 0,
      'originalId': '',
      'ref': '',
    });
    await FirebaseFirestore.instance.collection("posts").doc(doc.id).update({
      'originalId': doc.id,
      'ref': doc.id,
    });
  }

  Future saveEditPost(PostModel post, text) async {
    await FirebaseFirestore.instance.collection("posts").doc(post.id).update({
      'text': text,
      'updateAt': FieldValue.serverTimestamp(),
    });
  }

  Future reply(PostModel post, String text) async {
    await post.ref.collection("replies").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': false
    });
  }

  Future dislikePost(PostModel post) async {
    print("post.likesCount ${post.likesCount}");
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    await updateLike(postid: post.id);
  }

  Future likePost(PostModel post) async {
    print("post.likesCount ${post.likesCount}");
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
    await updateLike(postid: post.id);
  }

  Future updateLike({postid}) async {
    var count = await FirebaseFirestore.instance
        .collection("posts")
        .doc(postid)
        .collection("likes")
        .get();

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postid)
        .update({'likesCount': count.docs.length});
  }
  // Stream<List<PostModel>> getPostsByUser(uid) {
  //   return FirebaseFirestore.instance
  //       .collection("posts")
  //       .where('creator', isEqualTo: uid)
  //       .snapshots()
  //       .map(_postListFromSnapshot);
  // }
}
