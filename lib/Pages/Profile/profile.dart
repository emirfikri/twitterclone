import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/Pages/Auth/bloc/auth_bloc.dart';

import '../Auth/Signin/sign_in.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ProfileView(),
    );
  }

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocListener<AuthBloc, AuthState>(
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
      ),
    );
  }

  PreferredSize appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: const Text('Profile'),
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
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _avatar(),
              _changeAvatarButton(),
              const SizedBox(height: 30),
              _usernameTile(),
              _emailTile(),
              _descriptionTile(),
              _saveProfileChangesButton(),
            ],
          ),
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
      child: const Text('Change Avatar'),
    );
  }

  Widget _usernameTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: const Icon(Icons.person),
      title: Text(user.displayName ?? ""),
    );
  }

  Widget _emailTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: const Icon(Icons.mail),
      title: Text(user.email ?? ""),
    );
  }

  Widget _descriptionTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: const Icon(Icons.edit),
      title: TextFormField(
        // initialValue: state.userDescription,
        decoration: const InputDecoration.collapsed(
            hintText: 'Say something about yourself'),
        maxLines: null,
        // readOnly: !state.isCurrentUser,
        toolbarOptions: const ToolbarOptions(),
      ),
    );
  }

  Widget _saveProfileChangesButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Save Changes'),
    );
  }
}
