import 'package:flutter/material.dart';

class BuildError extends StatelessWidget {
  const BuildError({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Center(child: Text(text));
}
