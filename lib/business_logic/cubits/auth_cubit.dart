import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState { unauthenticated, authenticated }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.unauthenticated) {
    checkAuthState();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void checkAuthState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      print('State changed: $user : Cubit');
      if (user == null) {
        emit(AuthState.unauthenticated);
      } else {
        emit(AuthState.authenticated);
      }
    });
  }

  // Function to handle logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
