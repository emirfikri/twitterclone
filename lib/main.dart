import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Pages/Auth/Repo/auth_repo.dart';
import 'Pages/Auth/bloc/auth_bloc.dart';
import 'Pages/splashscreen/animatedsplashscreen.dart';
import 'configs/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          home: StreamBuilder<User?>(
              stream: authRepository.authStateChange(),
              builder: (context, snapshot) {
                return AnimatedSplashScreen(
                  user: snapshot,
                );
              }),
        ),
      ),
    );
  }
}
