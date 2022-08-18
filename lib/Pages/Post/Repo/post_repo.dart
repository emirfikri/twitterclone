import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/iterables.dart';
import 'package:twitterclone/Pages/Post/Repo/post_firestore_provider.dart';

import '../../../Models/postModel.dart';

class PostRepo {
  final PostFirestoreProvider postFirestoreProvider = PostFirestoreProvider();

  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc.get('text') ?? '',
        creator: doc.get('creator') ?? '',
        timestamp: doc.get('timestamp') ?? Timestamp.now(),
        likesCount: doc.get('likesCount') ?? 0,
        retweetsCount: doc.get('retweetsCount') ?? 0,
        retweet: doc.get('retweet') ?? false,
        originalId: doc.get('originalId') ?? '',
        ref: doc.reference,
      );
    }).toList();
  }

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
    postFirestoreProvider.savePost(text);
  }

  Future editPost(PostModel post, String text) async {
    postFirestoreProvider.saveEditPost(post, text);
  }

  Future reply(PostModel post, String text) async {
    if (text == '') {
      return;
    }
    await postFirestoreProvider.reply(post, text);
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

  Future retweet(PostModel post, bool current) async {
    if (current) {
      post.retweetsCount = post.retweetsCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("retweets")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection("posts")
          .where("originalId", isEqualTo: post.id)
          .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          return;
        }
        FirebaseFirestore.instance
            .collection("posts")
            .doc(value.docs[0].id)
            .delete();
      });
      // Todo remove the retweet
      return;
    }
    post.retweetsCount = post.retweetsCount + 1;
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
    DocumentReference docRefawait =
        await FirebaseFirestore.instance.collection("posts").add({
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': true,
      'originalId': post.id,
      'id': '',
      'ref': '',
      'text': post.text,
      'likesCount': 0,
      'retweetsCount': 0,
    });
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(docRefawait.id)
        .update({
      'id': docRefawait.id,
      'ref': docRefawait.id,
    });
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

  Stream<bool> getcurrentUserRetweet(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
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

  Stream<List<PostModel>> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future<List<PostModel>> getFeed() async {
    List<PostModel> feedList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    feedList.addAll(_postListFromSnapshot(querySnapshot));
    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate.compareTo(adate);
    });

    return feedList;
  }
}
