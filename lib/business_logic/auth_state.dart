import 'package:doni_pizza/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { initial, loading, success, failure }

class AuthState extends Equatable {
  final User? user;
  final UserModel? userModel;
  final String? error;
  final Status signInWithGoogleStatus;
  final Status signInWithEmailAndPasswordStatus;
  final Status registerWithEmailAndPasswordStatus;
  final Status userDataUpdateStatus;

  const AuthState({
    this.user,
    this.userModel,
    this.error,
    this.signInWithGoogleStatus = Status.initial,
    this.signInWithEmailAndPasswordStatus = Status.initial,
    this.registerWithEmailAndPasswordStatus = Status.initial,
    this.userDataUpdateStatus = Status.initial,
  });

  AuthState copyWith({
    User? user,
    UserModel? userModel,
    String? error,
    Status? signInWithGoogleStatus,
    Status? signInWithEmailAndPasswordStatus,
    Status? registerWithEmailAndPasswordStatus,
    Status? userDataUpdateStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error ?? this.error,
      userModel: userModel ?? this.userModel,
      signInWithGoogleStatus: signInWithGoogleStatus ?? this.signInWithGoogleStatus,
      signInWithEmailAndPasswordStatus:
          signInWithEmailAndPasswordStatus ?? this.signInWithEmailAndPasswordStatus,
      registerWithEmailAndPasswordStatus:
          registerWithEmailAndPasswordStatus ?? this.registerWithEmailAndPasswordStatus,
      userDataUpdateStatus: userDataUpdateStatus ?? this.userDataUpdateStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        error,
        userModel,
        signInWithGoogleStatus,
        signInWithEmailAndPasswordStatus,
        registerWithEmailAndPasswordStatus,
        userDataUpdateStatus,
      ];
}
