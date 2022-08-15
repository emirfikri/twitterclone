import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/Pages/Auth/Repo/auth_repo.dart';
import '../Auth/Signin/sign_in.dart';
import '../Auth/bloc/bloc_export.dart';

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
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = AuthBloc(
      authRepository: RepositoryProvider.of<AuthRepository>(context),
    );

    // Getting the user from the FirebaseAuth Instance

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => authBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
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
      child: InitialDisplay(),
    );
  }
}

class InitialDisplay extends StatelessWidget {
  const InitialDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Email: \n ${user.email}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          user.displayName != null ? Text("${user.displayName}") : Container(),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Sign Out'),
            onPressed: () {
              // Signing out the user
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
    );
  }
}
