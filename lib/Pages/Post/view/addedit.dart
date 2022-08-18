// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:twitterclone/Models/postModel.dart';
import '../bloc/bloc_export.dart';
import '/Pages/Dashboard/dashboard.dart';

import '../Repo/post_repo.dart';

class AddEditPost extends StatefulWidget {
  final PostModel? initialData;
  AddEditPost({Key? key, this.initialData}) : super(key: key);

  static Route<void> route({PostModel? initialData}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => PostBloc(
          initialData: initialData,
        ),
        child: AddEditPost(initialData: initialData),
      ),
    );
  }

  @override
  _AddEditPostState createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.initialData != null) {
      textEditingController.text = widget.initialData!.text;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
        actions: <Widget>[
          FlatButton(
              color: Colors.white,
              onPressed: () async {
                context
                    .read<PostBloc>()
                    .add(AddPost(textEditingController.text));
                Navigator.pushReplacement(context, Dashboard.route());
              },
              child: const Text('Tweet'))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Form(
          child: TextFormField(
            controller: textEditingController,
          ),
        ),
      ),
    );
  }
}
