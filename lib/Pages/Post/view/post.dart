import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/Pages/Dashboard/dashboard.dart';
import '../bloc/bloc_export.dart';
import '../Repo/post_repo.dart';
// import '/services/posts.dart';

import '../../../Models/postModel.dart';
import '../../../Models/userModel.dart';
import 'addedit.dart';

class ItemPost extends StatelessWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel?> snapshotUser;
  final AsyncSnapshot<bool> snapshotLike;

  ItemPost(this.post, this.snapshotUser, this.snapshotLike, {Key? key})
      : super(key: key);

  final PostRepo _postRepo = PostRepo();
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return ListTile(
          title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                onPressed: () {
                                  if (user.uid == post.creator) {
                                    showAlertDialog(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "You are not the author")));
                                  }
                                }),
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
                                            content: Text(
                                                "You can't Edit this tweet")));
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
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Continue"),
      onPressed: () {
        BlocProvider.of<PostBloc>(context).add(DeletePost(post));
        Navigator.pushReplacement(context, Dashboard.route());
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Delete tweet"),
      content: const Text("Would you like to continue delete?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
