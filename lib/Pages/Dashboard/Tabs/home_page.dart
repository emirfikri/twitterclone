import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Auth/bloc/bloc_export.dart';

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
