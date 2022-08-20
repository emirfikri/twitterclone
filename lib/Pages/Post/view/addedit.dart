// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitterclone/Models/postModel.dart';
import '../bloc/bloc_export.dart';
import '/Pages/Dashboard/dashboard.dart';

class AddEditPost extends StatefulWidget {
  final PostModel? initialData;
  const AddEditPost({Key? key, this.initialData}) : super(key: key);

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
  State<AddEditPost> createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
  int currentlength = 0;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    checkData();
    super.initState();
  }

  checkData() async {
    if (widget.initialData != null) {
      textEditingController.text = widget.initialData!.text;
      currentlength = textEditingController.text.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
        actions: <Widget>[
          FlatButton(
              color: Colors.blue,
              onPressed: () async {
                if (widget.initialData != null) {
                  context.read<PostBloc>().add(EditPost(
                      widget.initialData!, textEditingController.text));
                  Navigator.pushReplacement(context, Dashboard.route());
                } else {
                  context
                      .read<PostBloc>()
                      .add(AddPost(textEditingController.text));
                  Navigator.push(context, Dashboard.route());
                }
              },
              child: Row(
                children: const [
                  Text('Tweet'),
                  Icon(FontAwesomeIcons.twitter),
                ],
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Form(
          child: TextFormField(
            maxLines: 6,
            maxLength: 280,
            decoration: InputDecoration(
              counterText: "${currentlength} / 280",
            ),
            controller: textEditingController,
            onChanged: (value) {
              setState(() {
                currentlength = 280 - value.length;
              });
            },
          ),
        ),
      ),
    );
  }
}
