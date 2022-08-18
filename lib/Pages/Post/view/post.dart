import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Repo/post_repo.dart';
// import '/services/posts.dart';

import '../../../Models/postModel.dart';
import '../../../Models/userModel.dart';
import 'addedit.dart';

class ItemPost extends StatelessWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel?> snapshotUser;
  final AsyncSnapshot<bool> snapshotLike;
  final AsyncSnapshot<bool> snapshotRetweet;
  final bool retweet;

  ItemPost(this.post, this.snapshotUser, this.snapshotLike,
      this.snapshotRetweet, this.retweet,
      {Key? key})
      : super(key: key);

  final PostRepo _postRepo = PostRepo();
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snapshotRetweet.data! || retweet) const Text("Retweet"),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.person, size: 40),
                  const SizedBox(width: 10),
                  Text(snapshotUser.data!.displayName!)
                ],
              ),
            ],
          )),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.text),
                const SizedBox(height: 20),
                Text(post.timestamp.toDate().toString()),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.cancel,
                                color: Colors.red, size: 30.0),
                            onPressed: () {}),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.grey, size: 30.0),
                            onPressed: () {
                              if (post.creator == user.uid) {
                                print("post ${post.text}");
                                Navigator.push(context,
                                    AddEditPost.route(initialData: post));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("You can't Edit this tweet")));
                              }
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                                snapshotLike.data!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.blue,
                                size: 30.0),
                            onPressed: () {
                              _postRepo.likePost(
                                  post, snapshotLike.data ?? false);
                            }),
                        Text(post.likesCount.toString())
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
