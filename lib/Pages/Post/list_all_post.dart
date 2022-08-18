import 'package:flutter/material.dart';
import 'package:twitterclone/Pages/Post/Repo/post_repo.dart';
import 'package:twitterclone/Pages/Post/view/addedit.dart';
import '../../Models/postModel.dart';
import '../../Models/userModel.dart';
import '../../Repo/userService.dart';
import 'view/post.dart';

class ListPosts extends StatefulWidget {
  PostModel? post;
  ListPosts({
    Key? key,
    PostModel? post,
  }) : super(key: key);

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final UserService _userService = UserService();
  final PostRepo _postRepo = PostRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPost();
  }

  List<PostModel> posts = [];
  Future getAllPost() async {
    if (widget.post != null) {
      posts.add(widget.post!);
    } else {
      await PostRepo().getFeed().then((data) {
        setState(() {
          posts.addAll(data);
        });
      });
    }
    print("posts ${posts.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          if (post.retweet) {
            return FutureBuilder(
                future: _postRepo.getPostById(post.originalId),
                builder: (BuildContext context,
                    AsyncSnapshot<PostModel?> snapshotPost) {
                  print("snapshotPost ${snapshotPost.hasData}");
                  if (snapshotPost.hasData) {
                    print("snapshotPost ${snapshotPost.data}");
                  }
                  if (snapshotPost.hasData &&
                          snapshotPost.connectionState ==
                              ConnectionState.active ||
                      snapshotPost.connectionState == ConnectionState.done) {
                    return mainPost(snapshotPost.data!, true);
                  }
                  return const Center(child: CircularProgressIndicator());
                });
          }
          return mainPost(post, false);
        },
      ),
    );
  }

  StreamBuilder<UserModel?> mainPost(PostModel post, bool retweet) {
    return StreamBuilder(
        stream: _userService.getUserInfo(post.creator),
        builder:
            (BuildContext context, AsyncSnapshot<UserModel?> snapshotUser) {
          print("object ${snapshotUser.hasData} $snapshotUser");
          if (!snapshotUser.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          //stream builder to get user like
          return StreamBuilder(
              stream: _postRepo.getcurrentUserLike(post),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                if (!snapshotLike.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } //stream builder to get user like

                return StreamBuilder(
                    stream: _postRepo.getcurrentUserRetweet(post),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> snapshotRetweet) {
                      if (snapshotLike.hasData &&
                              snapshotRetweet.connectionState ==
                                  ConnectionState.active ||
                          snapshotRetweet.connectionState ==
                              ConnectionState.done) {
                        return ItemPost(post, snapshotUser, snapshotLike,
                            snapshotRetweet, retweet);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // return ItemPost(post, snapshotUser, snapshotLike,
                      //     snapshotRetweet, retweet);
                    });
              });
        });
  }
}
