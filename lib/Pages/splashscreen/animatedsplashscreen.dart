// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../Dashboard/dashboard.dart';
import '/Pages/Auth/Signin/sign_in.dart';
import '/helper/constants.dart';

import '../../configs/size_config.dart';
import 'package:flutter/material.dart';

class AnimatedSplashScreen extends StatefulWidget {
  final AsyncSnapshot<User?> user;

  const AnimatedSplashScreen({Key? key, required this.user}) : super(key: key);
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _visible = true;
  late AnimationController animationController;
  late Animation<double> animation;
  late Duration duration;

  initialise() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
  }

  startTime() async {
    duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    if (widget.user.hasData) {
      Navigator.pushReplacement(context, Dashboard.route());
    } else {
      Navigator.pushReplacement(context, SignIn.route());
    }
  }

  @override
  void initState() {
    super.initState();
    initialise();
    startTime();
  }

  @override
  void dispose() {
    animationController.dispose();
    animation.isDismissed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RotationTransition(
                turns: Tween(begin: 0.0, end: 2.0).animate(animationController),
                child: FlutterLogo(size: Constants.height * 0.3),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
