import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Add navigation to the sign-up screen or implement your logic here.
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: 'testuser@gmail.com', password: 'test123456');
                // authCubit.changeState(AuthState.authenticated);
              },
              child: const Text('Sign up'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Add navigation to the sign-in screen or implement your logic here.
                // You can also use authCubit for authentication.
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: 'testuser@gmail.com', password: 'test123456');
                // authCubit.changeState(AuthState.authenticated);
              },
              child: const Text('Sign in'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _googleSignIn.signOut();
                final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
                print('ok5');
                print(googleUser == null);
                if (googleUser == null) {
                  return null;
                }
                print('ok2');

                final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                print('ok3');
                final AuthCredential credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );
                print('ok4');
                final UserCredential authResult = await _auth.signInWithCredential(credential);
                print('ok5');
                // return authResult.user;
              },
              child: const Text('Continue with Google'),
            )
          ],
        ),
      ),
    );
  }
}
