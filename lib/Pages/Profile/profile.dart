import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/Pages/Auth/bloc/auth_bloc.dart';

import '../Auth/Repo/auth_repo.dart';
import '../Auth/Signin/sign_in.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = AuthBloc(
      authRepository: RepositoryProvider.of<AuthRepository>(context),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => authBloc,
        ),
      ],
      child: Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(child: buildBody()),
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
      child: _profilePage(),
    );
  }

  PreferredSize _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ));
  }

  Widget _profilePage() {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            _avatar(),
            _changeAvatarButton(),
            SizedBox(height: 30),
            _usernameTile(),
            _emailTile(),
            _descriptionTile(),
            _saveProfileChangesButton(),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return const CircleAvatar(
      radius: 50,
      child: Icon(Icons.person),
    );
  }

  Widget _changeAvatarButton() {
    return TextButton(
      onPressed: () {},
      child: Text('Change Avatar'),
    );
  }

  Widget _usernameTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(Icons.person),
      title: Text(user.displayName ?? ""),
    );
  }

  Widget _emailTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(Icons.mail),
      title: Text(user.email ?? ""),
    );
  }

  Widget _descriptionTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(Icons.edit),
      title: TextFormField(
        // initialValue: state.userDescription,
        decoration: const InputDecoration.collapsed(
            hintText: 'Say something about yourself'),
        maxLines: null,
        // readOnly: !state.isCurrentUser,
        toolbarOptions: ToolbarOptions(
            // copy: state.isCurrentUser,
            // cut: state.isCurrentUser,
            // paste: state.isCurrentUser,
            // selectAll: state.isCurrentUser,
            ),
        // onChanged: (value) => context
        //     .read<ProfileBloc>()
        //     .add(ProfileDescriptionChanged(description: value)),
      ),
    );
  }

  Widget _saveProfileChangesButton() {
    return ElevatedButton(
      onPressed: () {},
      child: Text('Save Changes'),
    );
  }
}
