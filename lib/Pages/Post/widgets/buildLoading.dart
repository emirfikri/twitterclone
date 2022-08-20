// ignore: file_names
import 'package:flutter/cupertino.dart';

class BuildLoading extends StatelessWidget {
  const BuildLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Center(child: CupertinoActivityIndicator());
}
