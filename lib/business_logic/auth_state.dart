import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { initial, loading, success, failure }

class AuthState extends Equatable {
  final User? user;
  final String? error;
  final Status signInWithGoogleStatus;
  final Status signInWithEmailAndPasswordStatus;
  final Status registerWithEmailAndPasswordStatus;

  const AuthState({
    this.user,
    this.error,
    this.signInWithGoogleStatus = Status.initial,
    this.signInWithEmailAndPasswordStatus = Status.initial,
    this.registerWithEmailAndPasswordStatus = Status.initial,
  });

  AuthState copyWith({
    User? user,
    String? error,
    Status? signInWithGoogleStatus,
    Status? signInWithEmailAndPasswordStatus,
    Status? registerWithEmailAndPasswordStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error ?? this.error,
      signInWithGoogleStatus: signInWithGoogleStatus ?? this.signInWithGoogleStatus,
      signInWithEmailAndPasswordStatus:
          signInWithEmailAndPasswordStatus ?? this.signInWithEmailAndPasswordStatus,
      registerWithEmailAndPasswordStatus:
          registerWithEmailAndPasswordStatus ?? this.registerWithEmailAndPasswordStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        error,
        signInWithGoogleStatus,
        signInWithEmailAndPasswordStatus,
        registerWithEmailAndPasswordStatus
      ];
}
