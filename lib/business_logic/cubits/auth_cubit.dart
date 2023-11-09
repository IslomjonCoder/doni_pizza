import 'package:doni_pizza/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStateEnum { unauthenticated, authenticated }

class AuthState {
  AuthStateEnum status;

  UserModel? userModel;
  User? user;

  AuthState({
    required this.status,
    this.userModel,
    this.user,
  });

  @override
  String toString() {
    return 'AuthState{status: $status, userModel: $userModel, user: $user}';
  }

  AuthState copyWith({
    AuthStateEnum? status,
    UserModel? userModel,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      user: user ?? this.user,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(status: AuthStateEnum.unauthenticated)) {
    checkAuthState();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void checkAuthState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      print('State changed: $user : Cubit');
      if (user == null) {
        emit(state.copyWith(status: AuthStateEnum.unauthenticated, user: user, userModel: null));
      } else {
        emit(state.copyWith(status: AuthStateEnum.authenticated, user: user));
      }
    });
  }
updateImageUrl(String url) {
    emit(state.copyWith(userModel: state.userModel?.copyWith(imageUrl: url)));
}
  updateUserModel(UserModel? model) {
    emit(state.copyWith(userModel: model));
  }
clearAll(){
  emit(state.copyWith(userModel: null, user: null, status: AuthStateEnum.unauthenticated));

}
  // Function to handle logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
