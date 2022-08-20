import 'dart:async';

import 'package:flutter/material.dart';
import 'package:twitterclone/Pages/Post/Repo/post_repo.dart';
import '../../Models/postModel.dart';
import '../../Models/userModel.dart';
import '../../Repo/userService.dart';
import 'bloc/bloc_export.dart';
import 'view/post.dart';
import 'widgets/buildError.dart';
import 'widgets/buildLoading.dart';

class ListPosts extends StatelessWidget {
  PostModel? post;
  ListPosts({
    Key? key,
    PostModel? post,
  }) : super(key: key);

  final UserRepo _userRepo = UserRepo();
  final PostRepo _postRepo = PostRepo();

  final PostBloc postBloc = PostBloc();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (BuildContext context) => postBloc,
        ),
      ],
      child: Scaffold(
        body: blocCategoryList(),
      ),
    );
  }

  Widget blocCategoryList() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostInitial) {
          postBloc.add(GetAllPost());
          return const BuildLoading();
        } else if (state is GetPostLoaded) {
          return allPostLoaded(state.allpost);
        } else if (state is PostError) {
          return BuildError(text: state.error);
        } else {
          return const BuildError(text: "Uknown Error");
        }
      },
    );
  }

  Widget allPostLoaded(Stream posts) {
    return StreamBuilder(
      stream: posts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const BuildLoading();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const BuildLoading();
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data.docs[index] != null) {
                  PostModel post =
                      PostModel.fromDocument(snapshot.data.docs[index]);
                  print("post id ${post.creator}");
                  return mainPost(post, false);
                } else {
                  return const BuildLoading();
                }
              },
            );
          } else {
            return const BuildLoading();
          }
        }
        return Container();
      },
    );
  }

  StreamBuilder<UserModel?> mainPost(PostModel post, bool retweet) {
    return StreamBuilder(
        stream: _userRepo.getUserInfo(post.creator),
        builder:
            (BuildContext context, AsyncSnapshot<UserModel?> snapshotUser) {
          if (!snapshotUser.hasData) {
            return const BuildLoading();
          }
          return StreamBuilder(
              stream: _postRepo.getcurrentUserLike(post),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                if (!snapshotLike.hasData) {
                  return const BuildLoading();
                } else if (snapshotLike.hasData &&
                        snapshotLike.connectionState ==
                            ConnectionState.active ||
                    snapshotLike.connectionState == ConnectionState.done) {
                  return ItemPost(post, snapshotUser, snapshotLike);
                } else if (snapshotLike.hasError) {
                  return const BuildLoading();
                }
                return ItemPost(post, snapshotUser, snapshotLike);
              });
        });
  }
}
