import 'package:flutter/material.dart';
import 'package:twitterclone/Pages/Auth/Repo/auth_repo.dart';
import '../../theme/colors.dart';
import '../Auth/Signin/sign_in.dart';
import '../Auth/bloc/bloc_export.dart';
import '../Profile/profile.dart';
import 'Pages/home_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const Dashboard(),
    );
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final List<Widget> _children = [
    const InitialDisplay(),
    Container(color: Colors.green),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = AuthBloc(
      authRepository: RepositoryProvider.of<AuthRepository>(context),
    );
    return BlocProvider(
      create: (BuildContext context) => authBloc,
      child: buildBody(
        scaffold: Scaffold(
          body: _children[currentIndex],
          bottomNavigationBar: BottomAppBar(
            child: bottomNavBar(0),
          ),
        ),
      ),
    );
  }

  buildBody({required Scaffold scaffold}) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          // Navigate to the sign in screen when the user Signs Out
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignIn()),
            (route) => false,
          );
        }
      },
      child: scaffold,
    );
  }

  Widget bottomNavBar(index) {
    return BottomAppBar(
      // ignore: sized_box_for_whitespace
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              // minWidth: Constants.width / 9,
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: currentIndex == 0
                        ? AppColor.firsttheme
                        : AppColor.secondtheme,
                    // size: Constants.width * 0.05,
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 10,
                      color: currentIndex == 0
                          ? AppColor.firsttheme
                          : AppColor.secondtheme,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              // minWidth: Constants.width / 9,
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.list,
                    color: currentIndex == 1
                        ? AppColor.firsttheme
                        : AppColor.secondtheme,
                    // size: Constants.width * 0.05,
                  ),
                  Text(
                    'My Tweet',
                    style: TextStyle(
                      fontSize: 10,
                      color: currentIndex == 1
                          ? AppColor.firsttheme
                          : AppColor.secondtheme,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              // minWidth: Constants.width / 9,
              onPressed: () {
                setState(() {
                  // if user taps on this dashboard tab will be active
                  currentIndex = 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.supervised_user_circle,
                    color: currentIndex == 2
                        ? AppColor.firsttheme
                        : AppColor.secondtheme,
                    // size: Constants.width * 0.05,
                  ),
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 10,
                      color: currentIndex == 2
                          ? AppColor.firsttheme
                          : AppColor.secondary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
