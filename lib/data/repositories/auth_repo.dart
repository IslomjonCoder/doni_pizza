import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doni_pizza/business_logic/cubits/user_data_cubit.dart';
import 'package:doni_pizza/data/models/user_model.dart';
import 'package:doni_pizza/main.dart';
import 'package:doni_pizza/presentation/ui/auth_screen/register_screen.dart';
import 'package:doni_pizza/utils/logging/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final userExist = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: googleUser.email)
          .get();
      if (userExist.docs.isNotEmpty) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        return authResult.user;
      }
      else{
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: navigatorKey.currentState!.context,
          dialogType: DialogType.info,
          animType: AnimType.bottomSlide,
          title: 'Register',
          desc: 'User not found. Please register.',
          btnOkOnPress: () {},
          btnOkText: 'Ok',
        ).show();
      }

    } on FirebaseAuthException catch (e) {
      TLoggerHelper.error(e.message!);
      throw Exception(e.message);
    } catch (e) {
      TLoggerHelper.error('Error signing in with Google: $e');
      throw Exception('Error signing in with Google: $e');
      // return null;
    }
    return null;
  }

  Future<User?> registerWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
       await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set(UserModel(
                  id: authResult.user!.uid,
                  name: navigatorKey.currentContext!.read<UserDataCubit>().state.name,
                  phoneNumber: navigatorKey.currentContext!.read<UserDataCubit>().state.phoneNumber,
                  email: googleUser.email)
              .toJson());
    } on FirebaseAuthException catch (e) {
      TLoggerHelper.error(e.message!);
      throw Exception(e.message);
    } catch (e) {
      TLoggerHelper.error('Error signing in with Google: $e');
      throw Exception('Error signing in with Google: $e');
      // return null;
    }
    return null;
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      TLoggerHelper.error('Error registering with email and password: $e');
      throw Exception('Error registering with email and password: $e');
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      TLoggerHelper.error('Error signing in with email and password: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
